#!/bin/bash

# Tools
yay -S --answerdiff None --answerclean None vi neovim ripgrep nvm openssh libfido2 ttf-ms-fonts

yay -S --answerdiff None --answerclean None docker docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker.service containerd.service

#gnupg pass git-credential-manager-core git-credential-manager-core-extras
# Setup GCM
# sudo gpg --gen-key | sed '3!d' | xargs pass init {}
#git config --global credential.credentialStore gpg

#echo "run gpg --gen-key"
#echo "run pass init <gpg-id>"
#echo "run git-credential-manager configure"
