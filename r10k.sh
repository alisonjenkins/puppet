#!/bin/bash
sudo pacman -Sy --noconfirm ruby
sudo gem install --no-user-install r10k
sudo gem install --no-user-install hiera-eyaml
r10k puppetfile install
