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
  owners = ["099720109477"] # Canonical's official AWS account ID
}

# Combined Jenkins Server (Master + Agent on one node due to AWS 1 vCPU limit)
resource "aws_instance" "jenkins_master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" 
  key_name                    = "jenkins-key" # <--- ADD THIS EXACT LINE
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.master_sg_id] 
  associate_public_ip_address = true
  iam_instance_profile        = var.jenkins_role_profile

# Install Java, Jenkins, Docker, and Git all on boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              
              # Install Java, Git, and Docker
              sudo apt-get install -y openjdk-17-jre docker.io git
              sudo systemctl enable docker
              sudo systemctl start docker
              
              # Install Jenkins (Using the strict GPG binary format)
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              
              sudo apt-get update
              sudo apt-get install -y jenkins
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              
              # Add users to docker group so pipelines can run containers
              sudo usermod -aG docker jenkins
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Jenkins-Combined-Server"
  }
}