output "ecs_execution_role_arn" {
  description = "ARN of the ECS Execution Role"
  value       = aws_iam_role.ecs_execution_role.arn
}

# (Note: If you haven't created the ecs_task_role in main.tf yet, you can point this to the execution role temporarily just to pass the plan)
output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_execution_role.arn 
}

output "jenkins_instance_profile" {
  description = "The IAM Instance Profile for Jenkins Agent"
  value       = aws_iam_instance_profile.jenkins_profile.name
}