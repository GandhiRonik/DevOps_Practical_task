# Fetch the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"]
}

# All-in-One Server (Master + Agent + App Server due to AWS 1 vCPU limit)
resource "aws_instance" "jenkins_master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" 
  key_name                    = "jenkins-key" 
  subnet_id                   = var.public_subnet_id
  
  # Attach all three security groups to this single server
  vpc_security_group_ids      = [var.master_sg_id, var.agent_sg_id, var.app_sg_id] 
  
  associate_public_ip_address = true
  iam_instance_profile        = var.jenkins_role_profile

  # Install Java 21, Jenkins, Docker, Git, and AWS CLI all on boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              
              # 1. Setup 2GB Swap Space
              sudo fallocate -l 2G /swapfile
              sudo chmod 600 /swapfile
              sudo mkswap /swapfile
              sudo swapon /swapfile
              
              # 2. Install Java 21, Git, Docker, and fontconfig
              sudo apt-get install -y openjdk-21-jre fontconfig docker.io git unzip
              sudo systemctl enable docker
              sudo systemctl start docker
              
              # 3. Install AWS CLI
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip && sudo ./aws/install
              
              # 4. Install Jenkins
              sudo mkdir -p /etc/apt/keyrings
              sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
              echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              
              sudo apt-get update -y
              sudo apt-get install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              
              # 5. Add users to docker group
              sudo usermod -aG docker jenkins
              sudo usermod -aG docker ubuntu
              EOF

  tags = { Name = "DevOps-All-In-One-Server" }
}