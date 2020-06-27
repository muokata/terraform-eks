provider "aws" {
  profile = "default"
  alias   = "route53-MUOKATANET" # provider's name
  region  = "us-east-1"
}

#######################################
#### muokata.net   ####################
#######################################

resource "aws_route53_zone" "eks-muokata" {
  provider = aws.route53-MUOKATANET
  name     = "eks.muokata.net"
  comment  = "Managed by Terraform"
}

resource "aws_route53_record" "eks-muokata-ns" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "eks.muokata.net"
  type     = "NS"
  ttl      = "30"

  records = [
    "${aws_route53_zone.eks-muokata.name_servers.0}",
    "${aws_route53_zone.eks-muokata.name_servers.1}",
    "${aws_route53_zone.eks-muokata.name_servers.2}",
    "${aws_route53_zone.eks-muokata.name_servers.3}",
  ]
}

# bastion host records
resource "aws_route53_record" "bastion-eks-muokata" {
  provider = aws.route53-MUOKATANET
  count    = var.server_count["bastion"]
  zone_id  = aws_route53_zone.eks-muokata.zone_id
  name     = "bastion-eks-${var.env}-${count.index}"
  type     = "A"
  ttl      = "300"
  records  = [element(aws_eip.bastion.*.public_ip, count.index)]
}
