#!/bin/bash

# for now just do collectstatic and migrations at start.  If multiple containers
# start being used, then figure out a better deploy strategy
cd $HOME/bash-shell.net/app/
PYENV_DIR=$(pyenv root)
# no need to sudo as soon as these go to digital ocean spaces
pipenv run python manage.py collectstatic --no-input
pipenv run python manage.py migrate --no-input
pipenv run gunicorn --workers 2 --bind 0.0.0.0:8000 --name django --max-requests=1000 bash_shell_net.wsgi:application
