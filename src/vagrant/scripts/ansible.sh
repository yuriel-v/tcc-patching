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
else
    echo "!!! Ansible install failed."
fi
