FROM debian:stretch-backports
# could also use the docker-elixir base image - it is
# based on erlang:19 which is also based on debian jessie
MAINTAINER Justin Michalicek <jmichalicek@gmail.com>
EXPOSE 8000

# This is what the official python docker images do and say it is required for py 3
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends sudo wget tar procps locales \
    ca-certificates apt-transport-https && apt-get autoremove && apt-get clean

RUN sed -i -e "s/# en_US.*/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=C.UTF-8

RUN useradd -U -ms /bin/bash django && echo "django ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER django
ENV PYENV_ROOT=/home/django/.pyenv
ENV PATH=$PYENV_ROOT/bin:$PYENV_ROOT/versions/3.6.3/bin:$PATH

# Build python using pyenv and then wipe out the build deps
WORKDIR /home/django
COPY build_python.sh /home/django/build_python.sh
RUN bash /home/django/build_python.sh
RUN $PYENV_ROOT/versions/3.6.3/bin/pip install pipenv
RUN mkdir -p /home/django/bash-shell.net/app/ && mkdir /home/django/bash-shell.net/static/ && mkdir /home/django/bash-shell.net/static_collected/
WORKDIR /home/django/bash-shell.net/

# set up apt repo for postgres stuff
# might make sense to either put this more towards the beginning for layer caching and sharing
# or possibly into a shell script to run along with pip install stuff if none of it is needed long term
RUN sudo apt-get install -y --no-install-recommends gnupg && sudo apt-get autoremove -y && sudo apt-get clean -y
RUN echo 'deb https://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
COPY pip.conf /home/django/pip.conf
ARG REPO_REFERENCE=master
# now install python packages into the virtualenv, these may need to build things, etc.
# and then wipe out the build deps
# the tar command strips the top level directory off of the extracted files
# since the tarball from github puts the files inside its own dir
RUN wget https://github.com/jmichalicek/bash-shell.net/archive/$REPO_REFERENCE.tar.gz \
    && tar -zxvf $REPO_REFERENCE.tar.gz --strip 1 -C ./app/ \
    && rm $REPO_REFERENCE.tar.gz
WORKDIR /home/django/bash-shell.net/app/

COPY install_python_packages.sh /home/django/install_python_packages.sh
RUN bash /home/django/install_python_packages.sh
ENV SMTP_HOST='' DATABASE_URL='' SMTP_PORT='' SMTP_USER='' SMTP_PASSWORD='' DJANGO_SETTINGS_MODULE='' REDIS_HOST='' \
  PYTHONIOENCODING="utf8" LC_ALL="en_US.UTF-8"
COPY run_django.sh /home/django/run_django.sh

## Expose static collected as volume so that it can be mounted/used elsewhere
#RUN $(pyenv root)/versions/blog/bin/python manage.py collectstatic --no-input
VOLUME ["/home/django/bash-shell.net/static_collected"]
#VOLUME ["/home/django/bash-shell.net/media"]

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/home/django/run_django.sh"]
