#!/bin/bash

export K9S_VERSION="0.27.4"
export K9S_RELEASE_FILE_NAME="k9s_Linux_amd64.tar.gz"
export HELM_VERSION="3.9.3"
export STERN_VERSION="1.25.0"
export LAZYDOCKER_VERSION="0.20.0"
export POPEYE_VERSION="0.11.1"
export TERRAFORM_VERSION="1.5.5"
export TERRAGRUNT_VERSION="0.49.1"

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi
cd /tmp/ || exit

function install_docker () {
    echo "Installing docker and docker-compose"
    sudo apt update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common curl gnupg ca-certificates lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-compose
    sudo systemctl enable docker
    sudo usermod -aG docker "$USER"
    echo "docker and docker-compose Installation Done"
    main_menu
}

function install_kubectl () {
    echo "Installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    main_menu
}

function install_helm () {
    echo "Installing helm"
    wget -O helm-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
    tar -zxvf helm-linux-amd64.tar.gz
    sudo install -o root -g root -m 0755 linux-amd64/helm /usr/local/bin/helm
    main_menu
}

function install_minikube () {
    echo "Installing minikube"
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
    main_menu
}

function install_k9s () {
    echo "Installing k9s"
    if [ -f "/tmp/${K9S_RELEASE_FILE_NAME}" ]; then
        rm -rf "/tmp/${K9S_RELEASE_FILE_NAME}"
    fi
    if [ -f "/usr/local/bin/k9s" ]; then
        rm -rf /usr/local/bin/k9s
    fi
    wget https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/${K9S_RELEASE_FILE_NAME}
    tar -xzvf ${K9S_RELEASE_FILE_NAME} 
    sudo install -o root -g root -m 0755 k9s /usr/local/bin/k9s
    main_menu
}

function install_stern () {
    echo "Installing stern"
    if [ -f "/usr/local/bin/stern" ]; then
        rm -rf /usr/local/bin/stern
    fi
    wget https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz
    tar -xzvf stern_${STERN_VERSION}_linux_amd64.tar.gz 
    rm -rf stern_${STERN_VERSION}_linux_amd64.tar.gz
    sudo install -o root -g root -m 0755 stern /usr/local/bin/stern
    main_menu
}

function install_lazydocker () {
    echo "Installing lazydocker"
    if [ -f "/usr/local/bin/lazydocker" ]; then
        rm -rf /usr/local/bin/lazydocker
    fi
    wget https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
    tar -xzvf lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz 
    rm -rf lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz
    sudo install -o root -g root -m 0755 lazydocker /usr/local/bin/lazydocker
    main_menu
}

function install_popeye () {
    echo "Installing popeye"
    if [ -f "/usr/local/bin/popeye" ]; then
        rm -rf /usr/local/bin/popeye
    fi
    wget https://github.com/derailed/popeye/releases/download/v${POPEYE_VERSION}/popeye_Linux_x86_64.tar.gz
    tar -xzvf popeye_Linux_x86_64.tar.gz 
    rm -rf popeye_Linux_x86_64.tar.gz
    sudo install -o root -g root -m 0755 popeye /usr/local/bin/popeye
    main_menu
}

function install_terraform () {
    echo "Installing terraform"
    if [ -f "/usr/local/bin/terraform" ]; then
        rm -rf /usr/local/bin/terraform
    fi
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo install -o root -g root -m 0755 terraform /usr/local/bin/terraform
    main_menu
}

function install_terragrunt () {
    echo "Installing terragrunt"
    if [ -f "/usr/local/bin/terragrunt" ]; then
        rm -rf /usr/local/bin/terragrunt
    fi
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
    sudo install -o root -g root -m 0755 terragrunt_linux_amd64 /usr/local/bin/terragrunt
    main_menu
}

# TODO: Add more tools
# awscli
# azure-cli
# gcp-cli
# oci-cli

function main_menu () {

    # Enter the number of the tool you want to install
    echo "Enter the number of the tool you want to install"
    echo "+-----+---------------------+"
    echo "|  1 | install docker      |"
    echo "|  2 | install lazydocker  |"
    echo "|  3 | install kubectl     |"
    echo "|  4 | install helm        |"
    echo "|  5 | install minikube    |"
    echo "|  6 | install k9s         |"
    echo "|  7 | Install stern       |"
    echo "|  8 | Install popeye      |"
    echo "|  9 | Install terraform   |"
    echo "| 10 | Install terragrunt  |"
    echo "|  0 | exit                |"
    echo "+-----+---------------------+"
    read -p "Enter your choice: " choice
    case $choice in
        1)
            install_docker
            ;;
        2)
            install_lazydocker
            ;;
        3)
            install_kubectl
            ;;
        4)
            install_helm
            ;;
        5)
            install_minikube
            ;;
        6)
            install_k9s
            ;;
        7)
            install_stern
            ;;
        8)
            install_popeye
            ;;
        9)
            install_terraform
            ;;
        10)
            install_terragrunt
            ;;
        0)
        exit
    esac
}

main_menu
