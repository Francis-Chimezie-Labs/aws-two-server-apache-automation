variable "aws_region" {
  description = "AWS region where the infrastructure will be created"
  type        = string
  default     = "us-east-2"
}

variable "my_ip_cidr" {
  description = "Public IP address allowed to SSH into the EC2 instances"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for EC2 access"
  type        = string
  default     = "~/.ssh/apache-two-server-key.pub"
}