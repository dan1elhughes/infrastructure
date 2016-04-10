#!/usr/bin/env bash

apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible

ln -sf /vagrant/ansible /home/vagrant/ansible
ln -sf /vagrant/ansible/hosts.ini /etc/ansible/hosts
