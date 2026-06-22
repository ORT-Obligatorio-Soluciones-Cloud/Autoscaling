output "asg_name" {
  description = "ID del auto scaling group"
  value = aws_autoscaling_group.asg.id
}
