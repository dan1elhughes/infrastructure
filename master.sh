#!/usr/bin/env bash

apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get install -y ansible

ln -sf /vagrant/ansible /home/vagrant
ln -sf /vagrant/ansible/hosts.ini /etc/ansible/hosts
ln -sf /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg

chmod 600 /home/vagrant/.ssh/id_rsa
