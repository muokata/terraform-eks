/*
###############################
#### Cluster Master policy ####
###############################
resource "aws_iam_role" "muokata-eks-master-role" {
  name = "muokata-eks-master-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Environement = var.env
  }
}


resource "aws_iam_role_policy_attachment" "muokata-eks-master-cluster-policy" {
  role       = aws_iam_role.muokata-eks-master-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "muokata-eks-master-service-policy" {
  role       = aws_iam_role.muokata-eks-master-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


###############################
#### Cluster Worker policy ####
###############################


resource "aws_iam_role" "muokata-eks-worker-role" {
  name = "muokata-eks-worker-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Environement = var.env
  }
}

resource "aws_iam_instance_profile" "muokata-eks-worker-profile" {
  name = "muokata-eks-worker-profile-${var.env}"
  role = aws_iam_role.muokata-eks-worker-role.name
}

resource "aws_iam_policy" "eks-worker-tagging" {
  name        = "eks-worker-tagging-${var.env}"
  description = "allow worker nodes to create ec2 tags"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DescribeTags"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "muokata-eks-worker-role" {
  role       = aws_iam_role.muokata-eks-worker-role.name
  policy_arn = aws_iam_policy.eks-worker-tagging.arn
}

resource "aws_iam_role_policy_attachment" "muokata-eks-worker-node" {
  role       = aws_iam_role.muokata-eks-worker-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "muokata-eks-worker-registry" {
  role       = aws_iam_role.muokata-eks-worker-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "muokata-eks-worker-cni" {
  role       = aws_iam_role.muokata-eks-worker-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
*/
