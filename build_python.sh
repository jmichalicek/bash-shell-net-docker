#!/bin/bash
# most of the pyenv recommended apt packages to build
# from https://github.com/pyenv/pyenv/wiki/Common-build-problems
sudo -E apt-get update && sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev wget curl llvm git && sudo apt-get autoremove && sudo apt-get clean

git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT 

echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bash_profile

eval "$(pyenv init -)"
$(pyenv root)/bin/pyenv install 3.6.3
pyenv global 3.6.3 system
sudo -E DEBIAN_FRONTEND=noninteractive apt-get purge -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev llvm git && sudo apt-get autoremove -y && sudo apt-get clean -y
