#Keypair
#Public key - utilized by EC2
resource "aws_key_pair" "TF-key" {
  key_name   = "TF-key"
  public_key = tls_private_key.ed25519-tf.public_key_openssh
}
# ED25519 key (Private Key)
resource "tls_private_key" "ed25519-tf" {
  algorithm = "ED25519"
}
#Private key storage in local file to SSH into server
resource "local_file" "tfkey" {
  content  = tls_private_key.ed25519-tf.private_key_pem
  filename = "${path.module}/tfkey"
}

#EC2 instances
resource "aws_instance" "webserver1" {
  ami                         = var.ami_id
  key_name                    = "TF-key"
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  instance_type               = var.instance_type
  subnet_id                   = var.pubsub_1
  vpc_security_group_ids      = [var.public_sg]
  tenancy                     = "default"
  
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "This is server 1" > /var/www/html/index.html
EOF

tags = {
    Name = "Webserver1"
  }
}

resource "aws_instance" "webserver2" {
  ami                         = var.ami_id
  key_name                    = "TF-key"
  associate_public_ip_address = true
  availability_zone           = "us-east-1b"
  instance_type               = var.instance_type
  subnet_id                   = var.pubsub_2
  vpc_security_group_ids      = [var.public_sg]
  tenancy                     = "default"
  
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "This is server 2" > /var/www/html/index.html
EOF

  tags = {
    Name = "Webserver2"
  }
}
