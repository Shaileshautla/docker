#!/bin/bash

# Go to terraform directory and get EC2 IP
cd ../terraform || exit
EC2_IP=$(terraform -chdir=terraform output -raw ec2_public_ip)

# Go to ansible directory
cd ../ansible-ec2-docker || exit

# Create Ansible inventory file
echo "[web]" > inventory.ini
echo "$EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/test.pem" >> inventory.ini

# Run the Ansible playbook
ansible-playbook -i inventory.ini install_docker.yml
