#!/bin/bash

# most of the pyenv recommended apt packages to build
# from https://github.com/pyenv/pyenv/wiki/Common-build-problems
sudo -E apt-get update && sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev wget curl llvm git && sudo apt-get autoremove && sudo apt-get clean

git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT 
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.6.2

sudo -E DEBIAN_FRONTEND=noninteractive apt-get purge -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev llvm git && sudo apt-get autoremove -y && sudo apt-get clean -y
