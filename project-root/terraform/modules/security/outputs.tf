output "alb_sg_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  description = "The ID of the ECS Application Security Group"
  value       = aws_security_group.app_sg.id
}

output "jenkins_master_sg_id" {
  description = "The ID of the Jenkins Master Security Group"
  value       = aws_security_group.jenkins_master_sg.id
}

output "jenkins_agent_sg_id" {
  description = "The ID of the Jenkins Agent Security Group"
  value       = aws_security_group.jenkins_agent_sg.id
}