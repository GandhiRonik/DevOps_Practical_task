provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Production"
      Project     = "DevOps-Practical-Test"
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "iam" {
  source = "../../modules/iam"
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source             = "../../modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnet_ids
  alb_security_group = module.security.alb_sg_id
}

module "ecs" {
  source              = "../../modules/ecs"
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnet_ids
  app_security_group  = module.security.app_sg_id
  target_group_arn    = module.alb.target_group_arn
  execution_role_arn  = module.iam.ecs_execution_role_arn
  task_role_arn       = module.iam.ecs_task_role_arn
}

module "jenkins" {
  source               = "../../modules/jenkins"
  public_subnet_id     = module.vpc.public_subnet_ids[0]
  private_subnet_id    = module.vpc.private_subnet_ids[0]
  master_sg_id         = module.security.jenkins_master_sg_id
  agent_sg_id          = module.security.jenkins_agent_sg_id
  jenkins_role_profile = module.iam.jenkins_instance_profile # <-- FIXED!
}