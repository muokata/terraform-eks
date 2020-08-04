resource "aws_security_group" "elb_main_ingress" {
  name        = "k8s-elb-ab17dad8aeeb74abe94c1b77b688c7c6"
  description = "Security group for Kubernetes ELB ab17dad8aeeb74abe94c1b77b688c7c6 (ingress-nginx/ingress-nginx-controller)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "65.95.237.148/32",
      "52.7.33.124/32",
      "192.241.184.74/32",
      "184.148.52.18/32",
      "70.27.103.246/32",
      "140.82.112.0/20",
      "192.30.252.0/22",
      "165.22.226.153/32",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "65.95.237.148/32",
      "52.7.33.124/32",
      "192.241.184.74/32",
      "184.148.52.18/32",
      "70.27.103.246/32",
      "140.82.112.0/20",
      "192.30.252.0/22",
      "165.22.226.153/32",
    ]
  }

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      "65.95.237.148/32",
      "52.7.33.124/32",
      "192.241.184.74/32",
      "184.148.52.18/32",
      "70.27.103.246/32",
    ]
  }

  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    cidr_blocks = [
      "65.95.237.148/32",
      "52.7.33.124/32",
      "192.241.184.74/32",
      "184.148.52.18/32",
      "70.27.103.246/32",
    ]
  }
  #ingress {
  #  from_port   = 0
  #  to_port     = 0
  #  protocol    = "-1"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                    = "muokata-eks-${var.env}-elb-main-ingress"
    Environment                             = var.env
    "kubernetes.io/cluster/muokata-eks-dev" = "owned"
  }

}



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
    cidr_blocks = ["67.71.177.28/32", "67.71.23.171/32", "165.22.226.153/32", "184.148.52.18/32", "70.27.103.246/32"]
  }

  ingress {
    from_port   = 5820
    to_port     = 5820
    protocol    = "tcp"
    cidr_blocks = ["67.71.177.28/32", "67.71.23.171/32", "165.22.226.153/32", "184.148.52.18/32", "70.27.103.246/32"]
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
