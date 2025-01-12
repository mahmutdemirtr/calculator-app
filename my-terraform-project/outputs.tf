output "instance_ip" {
  description = "Public IP of the created EC2 instance"
  value       = aws_instance.example.public_ip
}

output "instance_dns" {
  description = "Public DNS of the created EC2 instance"
  value       = aws_instance.example.public_dns
}
