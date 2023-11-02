#!/bin/bash

# Tools
yay -S neovim gnupg pass git-credential-manager-core 

# Setup GCM
sudo gpg --gen-key | sed '3!d' | xargs pass init {}
git config --global credential.credentialStore gpg
