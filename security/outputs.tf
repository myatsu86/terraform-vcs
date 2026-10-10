output "dashboard_security_group_id" {
  description = "ID of the dashboard security group"
  value       = aws_security_group.dashboard.id
}

output "counting_security_group_id" {
  description = "ID of the counting security group"
  value       = aws_security_group.counting.id
}
