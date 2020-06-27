provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

# Bastion Server 0
resource "aws_instance" "bastion" {
  ami                         = "ami-085925f297f89fce1"
  count                       = var.server_count["bastion"]
  subnet_id                   = element(module.vpc.public_subnets, count.index)
  associate_public_ip_address = "true"
  instance_type               = "t3.micro"

  root_block_device {
    volume_size = 40
  }

  tags = {
    Name        = "bastion-eks-${var.env}-${count.index}"
    Environment = var.env
    Subnet      = "public"
    Service     = "bastion"
  }

  # The path to your keyfile
  key_name = var.aws_key_name

  # security groups
  vpc_security_group_ids = [aws_security_group.bastion-client-eks.id, aws_security_group.internal-eks.id]

  user_data = <<EOF
#cloud-config
hostname: bastion-eks-${var.env}-${count.index}
manage_etc_hosts: true
fqdn: bastion-eks-${var.env}-${count.index}.muokata.com
EOF


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.key_file_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
    ]
  }
}
