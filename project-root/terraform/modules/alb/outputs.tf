output "target_group_arn" {
  description = "The ARN of the Target Group to be used by ECS"
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "The public DNS name of the Load Balancer"
  value       = aws_lb.main.dns_name
}