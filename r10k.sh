#!/bin/bash
sudo pacman -Sy ruby
sudo gem install --no-user-install r10k
r10k puppetfile install
