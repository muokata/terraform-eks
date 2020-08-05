variable "aws_key_name" {}
variable "key_file_path" {}
variable "profile" {}
#variable "muokata_net_zone_id" {}

variable "cluster_version" {
        default = "1.16"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "env" {
  default = "prod"
}

variable "server_count" {
  description = "number of instances to create"
  default = {
    bastion = "1"
  }
}

variable "dns_zones" {
  default = {
    muokatanet = "Z3BC0R4ZIT2AHT"
  }
}
