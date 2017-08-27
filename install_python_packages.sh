#!/bin/bash

#sudo apt-get update && sudo apt-get install -y --force-yes postgresql-client-9.6 libpq-dev libpq5 && sudo apt-get autoremove -y && sudo apt-get clean -y

sudo apt-get update && sudo apt-get install -y --force-yes libpq-dev libpq5 && sudo apt-get autoremove -y && sudo apt-get clean -y
sudo apt-get install -y libjpeg-dev libssl-dev libxml2-dev libxslt-dev && sudo apt-get autoremove -y && sudo apt-get clean -y
sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev git && sudo apt-get autoremove -y && sudo apt-get clean -y

$(pyenv root)/versions/blog/bin/pip install -r $HOME/bash-shell.net/app/requirements.txt

sudo apt-get purge -y libpq-dev && sudo apt-get autoremove -y && sudo apt-get clean -y
sudo apt-get purge -y libjpeg-dev libssl-dev libxml2-dev libxslt-dev && sudo apt-get autoremove -y && sudo apt-get clean -
sudo apt-get purge -y build-essential libssl-dev zlib1g-dev libbz2-dev git && sudo apt-get autoremove -y && sudo apt-get clean -y
