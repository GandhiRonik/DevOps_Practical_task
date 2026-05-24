variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_group" {
  description = "The security group ID for the ALB"
  type        = string
}