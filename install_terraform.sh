#!/bin/bash

###############
# Preperation #
###############

apt update
apt upgrade -y
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

################
# Dependencies #
################

apt install libguestfs-tools

##################################
# Install Terraform on ProxmoxVE #
##################################

apt install terraform
