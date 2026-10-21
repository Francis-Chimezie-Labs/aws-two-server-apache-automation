output "server_1_instance_id" {
  description = "Instance ID of Apache Server 1"
  value       = aws_instance.apache_server_1.id
}

output "server_1_public_ip" {
  description = "Public IP of Apache Server 1"
  value       = aws_instance.apache_server_1.public_ip
}

output "server_1_private_ip" {
  description = "Private IP of Apache Server 1"
  value       = aws_instance.apache_server_1.private_ip
}

output "server_2_instance_id" {
  description = "Instance ID of Apache Server 2"
  value       = aws_instance.apache_server_2.id
}

output "server_2_public_ip" {
  description = "Public IP of Apache Server 2"
  value       = aws_instance.apache_server_2.public_ip
}

output "server_2_private_ip" {
  description = "Private IP of Apache Server 2"
  value       = aws_instance.apache_server_2.private_ip
}