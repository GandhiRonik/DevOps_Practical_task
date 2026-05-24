output "jenkins_master_public_ip" {
  description = "The public IP of the All-In-One Jenkins Server"
  value       = aws_instance.jenkins_master.public_ip
}