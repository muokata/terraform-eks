terraform {
  backend "s3" {
    bucket = "terraform-muokata-eks"
    key    = "muokata-eks-0/terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "terraform-muokata-prod-lock"
  }
}

