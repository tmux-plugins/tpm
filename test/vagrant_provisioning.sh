#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y git-core expect python-software-properties software-properties-common

# install latest Tmux 1.9a
sudo add-apt-repository -y ppa:pi-rho/dev
sudo apt-get update
sudo apt-get install -y tmux=1.9a-1~ppa1~p
