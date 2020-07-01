module "eks" {
  source                       = "terraform-aws-modules/eks/aws"
  version                      = "~> 12.0.0"
  cluster_version              = "1.16"
  cluster_name                 = "muokata-eks-${var.env}"
  subnets                      = module.vpc.private_subnets
  write_kubeconfig             = false
  manage_worker_iam_resources  = false
  manage_cluster_iam_resources = false
  cluster_iam_role_name        = aws_iam_role.muokata-eks-master-role.name
  cluster_enabled_log_types    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = var.env
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3a.medium"
      #userdata_template_file        = "user_data/userdata.sh.tpl"
      iam_instance_profile_name     = aws_iam_instance_profile.muokata-eks-worker-profile.name
      #pre_userdata                  = data.template_cloudinit_config.cloudinit-worker-group-1.rendered
      asg_desired_capacity          = 3
      asg_min_size                  = 3
      asg_max_size                  = 5
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id, aws_security_group.all_worker_mgmt.id]
      key_name                      = var.aws_key_name
      public_ip                     = false
      tags = [
        {
          "key"                 = "environment"
          "value"               = "var.env"
          "propagate_at_launch" = "true"
        },
        {
          "key"                 = "worker_group"
          "value"               = "worker-group-1"
          "propagate_at_launch" = "true"
        }
      ]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3a.medium"
      #userdata_template_file        = "user_data/userdata.sh.tpl"
      iam_instance_profile_name     = aws_iam_instance_profile.muokata-eks-worker-profile.name
      #pre_userdata                  = data.template_cloudinit_config.cloudinit-worker-group-2.rendered
      asg_desired_capacity          = 0
      asg_min_size                  = 0
      asg_max_size                  = 0
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id, aws_security_group.all_worker_mgmt.id]
      key_name                      = var.aws_key_name
      public_ip                     = false
      tags = [
        {
          "key"                 = "environment"
          "value"               = "var.env"
          "propagate_at_launch" = "true"
        },
        {
          "key"                 = "worker_group"
          "value"               = "worker-group-2"
          "propagate_at_launch" = "true"
        }
      ]
    }

  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}
