#!/bin/bash

# Tools
yay -S --answerdiff None --answerclean None vi neovim lazygit nvm openssh libfido2 ttf-ms-fonts
#gnupg pass git-credential-manager-core git-credential-manager-core-extras
# Setup GCM
# sudo gpg --gen-key | sed '3!d' | xargs pass init {}
#git config --global credential.credentialStore gpg

#echo "run gpg --gen-key"
#echo "run pass init <gpg-id>"
#echo "run git-credential-manager configure"
