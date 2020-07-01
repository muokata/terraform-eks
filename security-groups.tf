resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "muokata-eks-${var.env}-worker_group_mgmt_one"
  description = "sec group for internal access to nodes in worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
  tags = {
    Name = "muokata-eks-${var.env}-worker_group_mgmt_one"
  }
}

resource "aws_security_group" "worker_group_mgmt_two" {
  name_prefix = "muokata-eks-${var.env}-worker_group_mgmt_two"
  description = "sec group for internal access to nodes in worker_group_mgmt_two"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
  tags = {
    Name = "muokata-eks-${var.env}-worker_group_mgmt_two"
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "muokata-eks-${var.env}-all_worker_management"
  description = "sec group for internal access to nodes in all worker groups"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
  tags = {
    Name = "muokata-eks-${var.env}-worker_group_mgmt_all"
  }
}

resource "aws_security_group" "bastion-client-eks" {
  name        = "bastion-client-eks-${var.env}"
  description = "Vpn and bastion host access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["67.71.177.28/32", "67.71.23.171/32", "165.22.226.153/32"]
  }

  ingress {
    from_port   = 5820
    to_port     = 5820
    protocol    = "tcp"
    cidr_blocks = ["67.71.177.28/32", "67.71.23.171/32", "165.22.226.153/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bastion-client-eks-${var.env}"
    Environment = var.env
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "internal-eks" {
  name        = "internal-eks-${var.env}"
  description = "Internal access"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "internal-eks-${var.env}"
    Environment = var.env
  }

  vpc_id = module.vpc.vpc_id
}
