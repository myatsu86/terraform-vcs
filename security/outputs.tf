output "allow_all_security_group_id" {
  description = "ID of the allow-all security group"
  value       = aws_security_group.allow_all.id
}
