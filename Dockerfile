FROM debian:stretch-backports
# could also use the docker-elixir base image - it is
# based on erlang:19 which is also based on debian jessie
MAINTAINER Justin Michalicek <jmichalicek@gmail.com>
EXPOSE 8000

# This is what the official python docker images do and say it is required for py 3
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends sudo wget tar procps \
    ca-certificates apt-transport-https && apt-get autoremove && apt-get clean

RUN useradd -ms /bin/bash django && echo "django ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER django
ENV HOME=/home/django
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Build python using pyenv and then wipe out the build deps
WORKDIR $HOME
COPY build_python.sh $HOME/build_python.sh
RUN bash $HOME/build_python.sh

RUN mkdir -p /home/django/bash-shell.net/app/ && mkdir /home/django/bash-shell.net/static/
ARG REPO_REFERENCE=master
WORKDIR /home/django/bash-shell.net/

# set up apt repo for postgres stuff
# might make sense to either put this more towards the beginning for layer caching and sharing
# or possibly into a shell script to run along with pip install stuff if none of it is needed long term
RUN sudo apt-get install -y --no-install-recommends gnupg && sudo apt-get autoremove -y && sudo apt-get clean -y
RUN echo 'deb https://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# now install python packages into the virtualenv, these may need to build things, etc.
# and then wipe out the build deps
# the tar command strips the top level directory off of the extracted files
# since the tarball from github puts the files inside its own dir
RUN echo 1
RUN wget https://github.com/jmichalicek/bash-shell.net/archive/$REPO_REFERENCE.tar.gz \
    && tar -zxvf $REPO_REFERENCE.tar.gz --strip 1 -C ./app/ \
    && rm $REPO_REFERENCE.tar.gz
WORKDIR /home/django/bash-shell.net/app/

RUN pyenv virtualenv 3.6.2 bash-shell-net
COPY install_python_packages.sh $HOME/install_python_packages.sh
RUN bash $HOME/install_python_packages.sh

ENV SMTP_HOST='' DATABASE_URL='' SMTP_PORT='' SMTP_USER='' SMTP_PASSWORD='' DJANGO_SETTINGS_MODULE=''

## Expose static collected as volume so that it can be mounted/used elsewhere
#RUN $(pyenv root)/versions/bash-shell-net/bin/python manage.py collectstatic --no-input
VOLUME [/home/django/bash-shell.net/static_collected]
#VOLUME [/home/django/bash-shell.net/media]

ENTRYPOINT ["/bin/bash", "-c"]
