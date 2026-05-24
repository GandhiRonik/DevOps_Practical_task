terraform {
  backend "s3" {
    bucket         = "tfstate-devops-practical-task"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}