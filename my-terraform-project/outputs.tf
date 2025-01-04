output "instance_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.example.public_ip
}
