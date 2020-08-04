provider "aws" {
  profile = "default"
  alias   = "route53-MUOKATANET" # provider's name
  region  = "us-east-1"
}

resource "aws_route53_record" "prometheus" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "prometheus.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "alertmanager" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "alertmanager.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "grafana" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "grafana.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "argocd" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "argocd.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}
resource "aws_route53_record" "docs-muokata-net" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "docs.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}

#######################################
#### prod.eks.muokata.net #############
#######################################

resource "aws_route53_zone" "prod-eks-muokata" {
  provider = aws.route53-MUOKATANET
  name     = "prod.eks.muokata.net"
  comment  = "Managed by Terraform"
}

resource "aws_route53_record" "prod-eks-muokata-ns" {
  provider = aws.route53-MUOKATANET
  zone_id  = var.dns_zones["muokatanet"]
  name     = "prod.eks.muokata.net"
  type     = "NS"
  ttl      = "30"

  records = [
    "${aws_route53_zone.prod-eks-muokata.name_servers.0}",
    "${aws_route53_zone.prod-eks-muokata.name_servers.1}",
    "${aws_route53_zone.prod-eks-muokata.name_servers.2}",
    "${aws_route53_zone.prod-eks-muokata.name_servers.3}",
  ]
}

# bastion host records
resource "aws_route53_record" "bastion-eks-muokata" {
  provider = aws.route53-MUOKATANET
  count    = var.server_count["bastion"]
  zone_id  = aws_route53_zone.prod-eks-muokata.zone_id
  name     = "bastion-eks-${var.env}-${count.index}"
  type     = "A"
  ttl      = "300"
  records  = [element(aws_eip.bastion.*.public_ip, count.index)]
}

resource "aws_route53_record" "docs" {
  provider = aws.route53-MUOKATANET
  zone_id  = aws_route53_zone.prod-eks-muokata.zone_id
  name     = "*.prod.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}

resource "aws_route53_record" "docs-eks" {
  provider = aws.route53-MUOKATANET
  zone_id  = aws_route53_zone.prod-eks-muokata.zone_id
  name     = "docs.prod.eks.muokata.net"
  type     = "CNAME"
  ttl      = "300"
  records  = ["ab17dad8aeeb74abe94c1b77b688c7c6-145601780.us-east-1.elb.amazonaws.com"]
}
