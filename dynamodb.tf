resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-muokata-${var.env}-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
