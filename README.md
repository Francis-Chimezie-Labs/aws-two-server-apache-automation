# AWS Two-Server Apache Automation

## Project Overview

This project demonstrates automated provisioning, configuration, and management of two Ubuntu web servers running Apache on AWS EC2.

AWS infrastructure was provisioned using Terraform, both EC2 servers were configured simultaneously using Ansible, and Python with Boto3 was used to communicate with AWS and check the running state of the EC2 instances.

The project demonstrates practical Cloud and DevOps concepts including:

- Infrastructure as Code
- Configuration as Code
- Multi-server configuration management
- Python cloud automation
- AWS API interaction
- Linux administration
- Web server deployment

---

## Architecture

```text
                    Internet
                       |
                Internet Gateway
                       |
                 Public Route Table
                       |
                  Public Subnet
                  10.60.1.0/24
                  /           \
                 /             \
        Apache Server 1    Apache Server 2
            EC2                EC2
          Ubuntu             Ubuntu
          Apache             Apache
                 \             /
                  \           /
                     Ansible
                  Control Node
                       |
                  Python/Boto3
                       |
                    AWS API
```

---

## AWS Region

The infrastructure was deployed in:

```text
us-east-2 (Ohio)
```

---

## Technologies Used

- AWS EC2
- AWS VPC
- Public Subnet
- Internet Gateway
- Route Tables
- Security Groups
- Terraform
- Ansible
- Python
- Boto3
- Apache
- Ubuntu 24.04 LTS
- SSH
- Jinja2 Templates
- Git
- GitHub

---

## Infrastructure Provisioning with Terraform

Terraform was used to provision the AWS infrastructure required for the project.

The infrastructure included:

- Custom VPC
- Public subnet
- Internet Gateway
- Public route table
- Route table association
- Security group
- EC2 key pair
- Two Ubuntu EC2 instances

The security group was configured to allow:

- SSH access on port 22 from the administrator's public IP
- HTTP access on port 80 for web traffic
- Outbound internet access

Terraform allowed the infrastructure to be defined as code instead of manually creating each resource through the AWS Console.

---

## Ansible Configuration Management

Ansible was used to configure both EC2 instances from a single control node.

Both servers were placed inside the Ansible inventory group:

```ini
[webservers]
apache-server-1
apache-server-2
```

The Ansible playbook performs the following configuration tasks:

1. Connects to both EC2 instances
2. Gathers system information
3. Updates the Ubuntu package cache
4. Installs Apache
5. Ensures Apache is running
6. Enables Apache to start automatically
7. Deploys a custom webpage using a Jinja2 template

A single Ansible command manages both servers:

```bash
ansible-playbook -i inventory.ini site.yml
```

---

## Ansible Connectivity Test

Before running the playbook, connectivity to both servers was verified using:

```bash
ansible webservers -i inventory.ini -m ping
```

Successful output confirmed that Ansible could communicate with both EC2 instances:

```text
apache-server-1 | SUCCESS
"ping": "pong"

apache-server-2 | SUCCESS
"ping": "pong"
```

---

## Apache Web Server Deployment

Apache was installed and configured automatically on both EC2 instances.

The playbook ensures that Apache is:

- Installed
- Running
- Enabled at system startup

The Apache service was also verified using Ansible.

Both servers successfully returned:

```text
active
```

HTTP connectivity was tested and both servers returned:

```text
HTTP/1.1 200 OK
```

---

## Custom Jinja2 Webpage

A Jinja2 template is used to deploy a custom webpage to both Apache servers.

The same template is reused across both servers while Ansible automatically inserts information specific to each machine.

The webpage displays:

- Project owner
- Server name
- Private IP address
- AWS region
- Operating system
- Web server
- Infrastructure platform
- Provisioning tool
- Configuration management tool

Example:

```text
Francis C. Osondu
Cloud & DevOps Automation Project

apache-server-1

Apache Web Server Successfully Deployed

AWS Region: us-east-2 (Ohio)
Operating System: Ubuntu 24.04 LTS
Web Server: Apache
Infrastructure: AWS EC2
Provisioning: Terraform
Configuration Management: Ansible
```

The second EC2 instance automatically displays:

```text
apache-server-2
```

This demonstrates how one reusable Ansible template can configure multiple servers with host-specific information.

---

## Ansible Idempotency

The Ansible playbook was executed multiple times to verify idempotency.

On the first deployment, Ansible made the necessary configuration changes.

After the servers reached the desired configuration, the same playbook was run again.

The result was:

```text
apache-server-1 : ok=5 changed=0 unreachable=0 failed=0
apache-server-2 : ok=5 changed=0 unreachable=0 failed=0
```

The important value is:

```text
changed=0
```

This proves that Ansible recognized that the servers were already configured correctly and did not make unnecessary changes.

---

## Python Automation

Python was added to the project to demonstrate custom cloud automation.

A Python script uses Boto3, the AWS SDK for Python, to communicate directly with AWS.

The script checks the current state of both EC2 instances.

Example output:

```text
Apache Server 1 is RUNNING.
Apache Server 2 is RUNNING.
```

The script demonstrates the use of:

- Python variables
- Dictionaries
- For loops
- If / elif / else logic
- Boto3
- AWS APIs

---

## Python and Boto3 Environment

A Python virtual environment was created for the project:

```bash
python3 -m venv .venv
```

The environment is activated using:

```bash
source .venv/bin/activate
```

Boto3 was installed inside the virtual environment:

```bash
pip install boto3
```

AWS authentication was successfully tested before running the automation script.

The Python dependencies are stored in:

```text
requirements.txt
```

They can be installed using:

```bash
pip install -r requirements.txt
```

---

## EC2 Python Verification

Python was also verified directly on the Ubuntu EC2 instance using:

```bash
python3 --version
```

Python 3 was available on the server.

A simple Python script was also created directly on the EC2 instance to display project information:

```python
name = "Francis C. Osondu"
region = "us-east-2"

print("Name:", name)
print("AWS Region:", region)
```

Example output:

```text
Name: Francis C. Osondu
AWS Region: us-east-2
```

---

## Configuration as Code

This project demonstrates Configuration as Code through Ansible.

Instead of manually connecting to each server and installing or configuring Apache one server at a time, the required configuration is stored inside the Ansible playbook.

This makes the configuration:

- Repeatable
- Consistent
- Reusable
- Easier to maintain
- Easier to automate across multiple servers

---

## Infrastructure as Code

Terraform was used to define AWS infrastructure as code.

Instead of manually creating VPCs, subnets, routing, security groups, and EC2 instances through the AWS Console, the desired infrastructure was defined using Terraform configuration files.

This provides a repeatable and consistent infrastructure deployment process.

---

## Project Structure

```text
apache-two-server-ansible/
│
├── README.md
├── .gitignore
├── inventory.example.ini
├── requirements.txt
├── site.yml
│
├── scripts/
│   └── check_ec2_status.py
│
└── templates/
    └── index.html.j2
```

The real `inventory.ini` file is excluded from GitHub because it contains environment-specific information such as public IP addresses and the local SSH private-key path.

The Python virtual environment `.venv` is also excluded from GitHub.

---

## Example Inventory

A safe example inventory is provided as:

```text
inventory.example.ini
```

Example:

```ini
[webservers]
apache-server-1 ansible_host=SERVER_1_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/private-key
apache-server-2 ansible_host=SERVER_2_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/private-key
```

Users can copy this file and replace the placeholders with their own environment information.

---

## Running the Ansible Project

### 1. Create the inventory

```bash
cp inventory.example.ini inventory.ini
```

Update `inventory.ini` with the correct EC2 public IP addresses and SSH private-key path.

### 2. Test Ansible connectivity

```bash
ansible webservers -i inventory.ini -m ping
```

### 3. Check the playbook syntax

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
```

### 4. Run the playbook

```bash
ansible-playbook -i inventory.ini site.yml
```

### 5. Run the playbook again to verify idempotency

```bash
ansible-playbook -i inventory.ini site.yml
```

A properly configured environment should return:

```text
changed=0
failed=0
unreachable=0
```

for both servers.

---

## Running the Python EC2 Status Script

### 1. Create a virtual environment

```bash
python3 -m venv .venv
```

### 2. Activate it

```bash
source .venv/bin/activate
```

### 3. Install the dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure valid AWS credentials

The environment running the script must have permission to query EC2 resources.

### 5. Run the script

```bash
python3 scripts/check_ec2_status.py
```

Example output:

```text
Apache Server 1 is RUNNING.
Apache Server 2 is RUNNING.
```

---

## Security Practices

Several security practices were followed during the project:

- SSH access was restricted to a specific administrator IP
- The SSH private key was not stored in the project repository
- The real Ansible inventory was excluded from GitHub
- AWS credentials were not hard-coded into Python files
- HTTP and SSH were controlled through AWS Security Groups
- Environment-specific information was separated from reusable project files

---

## Key Skills Demonstrated

This project demonstrates practical experience with:

- AWS infrastructure
- EC2 administration
- VPC networking
- Public subnets
- Internet Gateways
- Route Tables
- Security Groups
- Infrastructure as Code
- Terraform
- Configuration as Code
- Ansible
- Multi-server automation
- Ansible inventories
- Ansible playbooks
- Ansible modules
- Ansible facts
- Ansible idempotency
- Jinja2 templates
- Apache administration
- Ubuntu Linux
- SSH
- Python scripting
- Boto3
- AWS API interaction
- Python virtual environments
- Cloud automation
- Git and GitHub

---

## Project Outcome

The completed environment consists of two Ubuntu EC2 web servers running Apache.

Terraform provisions the AWS infrastructure.

Ansible automatically configures both servers and deploys the web content.

Jinja2 dynamically identifies each server.

Python and Boto3 communicate with AWS to check EC2 instance states.

The final workflow demonstrates how multiple Cloud and DevOps automation tools can work together:

```text
Terraform
    |
    v
AWS Infrastructure
    |
    v
Two EC2 Servers
    |
    v
Ansible Configuration
    |
    v
Apache Web Servers
    |
    v
Jinja2 Web Deployment

Python + Boto3
    |
    v
AWS API
    |
    v
EC2 Status Monitoring
```

## Operational Validation

After deployment, the environment can be validated using a combination of Terraform, Ansible, HTTP checks, and Python automation.

### Infrastructure Validation

Terraform can be used to confirm the resources being managed:

```bash
terraform state list

---

## Author

**Francis C. Osondu**

Cloud & DevOps Automation Project