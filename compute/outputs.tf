output "counting_instance_id" {
  description = "ID of the counting EC2 instance"
  value       = aws_instance.counting.id
}

output "counting_private_ip" {
  description = "Private IP of the counting EC2 instance"
  value       = aws_instance.counting.private_ip
}

output "dashboard_instance_id" {
  description = "ID of the dashboard EC2 instance"
  value       = aws_instance.dashboard.id
}

output "dashboard_public_ip" {
  description = "Public IP of the dashboard EC2 instance"
  value       = aws_instance.dashboard.public_ip
}
