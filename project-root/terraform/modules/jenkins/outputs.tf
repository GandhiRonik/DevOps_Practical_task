output "jenkins_master_public_ip" {
  description = "The public IP of the Jenkins Master"
  value       = aws_instance.jenkins_master.public_ip
}