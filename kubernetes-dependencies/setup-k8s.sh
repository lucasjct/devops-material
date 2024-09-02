#!/bin/bash

# ------------------------------------------------------------------------ #
# Script Name:   zora-setup.sh
# Description:   Instal setup necessary to run Zora
# Written by:    Lucas
# Maintenance:   Lucas
# ------------------------------------------------------------------------ #
# Usage:
#       $ ./zora-setup.sh
# ------------------------------------------------------------------------ #
# Tested on:
#       5.1.16(1)-release (x86_64-pc-linux-gnu)
# ------------------------------------------------------------------------ #


# KUBECTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
kubectl version --output=yaml

# DOCKER
if command -v docker &> /dev/null; then
    echo "Docker already installed."
   
else 
    curl -fsSL https://get.docker.com | bash
    docker version
fi

# KIND
CPU_ARCH=$(uname -m)

if [ "$CPU_ARCH" == "x86_64" ]; then
    echo "Installing to version": $CPU_ARCH
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    kind
elif [ "$CPU_ARCH" == "aarch64" ]; then
    echo "Installing to version": $CPU_ARCH
    [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    kind
else
    echo "Something is wrong, fix it and triy again."
fi

# HELM
echo "Installing HELM"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
helm version


SKIP=0 
while [ "$SKIP" == 0 ]
do
    read -p "Do you want to create a Kind cluster and install Zora? (Y/N): " REPLY

    if [ "$REPLY" == "Y" ] || [ "$REPLY" == "y" ]; then
        kind create cluster
        # install zora
        helm repo add undistro https://charts.undistro.io --force-update
        helm repo update undistro
        helm upgrade --install zora undistro/zora \
            -n zora-system \
            --version 0.9.3 \
            --create-namespace \
            --wait \
            --set clusterName="$(kubectl config current-context)"
        SKIP=1

    elif  [ "$REPLY" == "N" ] || [ "$REPLY" == "n" ]; then
        echo "Don't worries."
        SKIP=1
    else
        echo "Invalid option. Please choose a valid one."
    fi
done

echo "Zora setup completed successfully!"
