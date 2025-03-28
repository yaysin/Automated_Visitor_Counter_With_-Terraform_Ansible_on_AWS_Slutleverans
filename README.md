INFRASTRUCTURE SETUP GUIDE:

Prerequisites:

Have an AWS account.
Ensure OpenTofu is installed on your system.
Ensure Ansible is installed on your system.
Ensure AWS CLI is installed on your system and configured with your AWS account.
Have an SSH key pair and know the path to the private key file of this key pair.

Creating Infrastructure with Terraform:
Save the Terraform files (main.tf, variables.tf, outputs.tf, provider.tf) to a directory.
Create the .tfvars file and assign values to the required variables (e.g., AWS region, AMI ID, SSH key name, database password).
Initialize Terraform: terraform init
Create the infrastructure: terraform apply
Record the values from the Terraform outputs (e.g., Load Balancer DNS name, web server IP addresses, database endpoint) in a location.

Configuration and Deployment with Ansible:
Save the Ansible files (ansible.cfg, inventory, playbook.yml, roles/templates/db_config.php.j2) to a directory.
Configure the ansible.cfg file to include the path to your SSH key file and other settings.
Edit the inventory file to include the EC2 instance IP addresses and database endpoint obtained from the Terraform outputs.
Run the Ansible playbook: ansible-playbook playbook.yml
![image](https://github.com/user-attachments/assets/894d46dc-cfa3-4c88-8c09-8c55f3522125)


Testing the Application:
Try accessing the application by visiting the load balancer's DNS address in your web browser.

The project diagram is as shown in the image. Auto Scaling was not used in the project. However, it is being considered for future implementation.
![image](https://github.com/user-attachments/assets/626ffbe0-b5b5-4fb9-af81-c9d6a38c2b03)
