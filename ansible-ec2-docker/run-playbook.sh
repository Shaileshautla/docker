#!/bin/bash

# Move to the Terraform directory
cd terraform || exit 1

# Get the EC2 public IP output from Terraform
INSTANCE_IP=$(terraform output -raw ec2_public_ip)

# Optional: print IP for debug
echo "Extracted EC2 IP: $INSTANCE_IP"

# Go to Ansible directory
cd ../ansible-ec2-docker || exit 1

# Create the inventory file
echo "[web]" > inventory.ini
echo "$INSTANCE_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/test.pem" >> inventory.ini

# Show inventory for confirmation
cat inventory.ini

# Run the Ansible playbook
ansible-playbook -i inventory.ini install_docker.yml
