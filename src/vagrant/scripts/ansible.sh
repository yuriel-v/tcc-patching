#!/bin/bash
# Script para instalação do Ansible em CentOS ou Fedora via DNF
echo "===== Installing EPEL ====="
dnf install -y epel-release

echo "===== Caching package information ====="
dnf makecache

echo "===== Installing Ansible ====="
dnf install -y ansible

echo "===== Validating Ansible install ====="
if ansible --version >/dev/null; then
    echo "--> Ansible install successful."

    echo "===== Cloning Ansible repo to Vagrant user home ====="
    # NOTA: um sparse checkout é feito aqui para clonar somente o dir com os
    # playbooks Ansible da solução. Isso não é ideal!
    # O ideal seria ter um repo a parte somente com os códigos Ansible.
    #
    # Aqui faço esse workaround por conveniência de deixar a solução completa
    # em um único repo, mas novamente, em um ambiente de trabalho por exemplo,
    # isso não é ideal!

    cd /tmp
    timestamp=$(date +%d%m%y%H%M%S)
    mkdir "$timestamp"
    cd "$timestamp"

    git init -b master >/dev/null
    git config core.sparsecheckout true >/dev/null
    echo "src/ansible" >> .git/info/sparse-checkout
    git remote add -f origin https://github.com/yuriel-v/tcc-patching.git >/dev/null
    git pull origin master >/dev/null

    mv src/ansible /home/vagrant
    cd /
    rm -rf "/tmp/$timestamp"
    chown -R vagrant:vagrant /home/vagrant/ansible
else
    echo "!!! Ansible install failed."
fi
