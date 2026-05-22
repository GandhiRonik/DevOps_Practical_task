terraform {
  backend "s3" {
    bucket         = "company-production-tf-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}