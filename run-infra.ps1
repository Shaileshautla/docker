# Run Terraform
Write-Host "Applying Terraform..."
cd "C:\Temp\docker\terraform"
terraform init
terraform apply -auto-approve

# Wait for EC2 to be accessible
Start-Sleep -Seconds 30

# Run Ansible playbook
Write-Host "Running Ansible..."
cd "C:\Temp\docker\ansible-ec2-docker"
bash ./run-playbook.sh
