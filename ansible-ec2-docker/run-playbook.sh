#!/bin/bash

cd ../terraform
EC2_IP=$(terraform output -raw ec2_public_ip)
cd ../ansible-ec2-docker

echo "[ec2]" > inventory.ini
echo "$EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/test.pem" >> inventory.ini

ansible-playbook -i inventory.ini install_docker.yml
