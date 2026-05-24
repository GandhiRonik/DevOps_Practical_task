variable "public_subnet_id" {
  description = "Public subnet ID for Jenkins Master"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for Jenkins Agent"
  type        = string
}

variable "master_sg_id" {
  description = "Security Group ID for Jenkins Master"
  type        = string
}

variable "agent_sg_id" {
  description = "Security Group ID for Jenkins Agent"
  type        = string
}

variable "jenkins_role_profile" {
  description = "IAM Instance Profile for Jenkins"
  type        = string
}

variable "app_sg_id" {
  description = "Security Group ID for the Target Application Server"
  type        = string
}