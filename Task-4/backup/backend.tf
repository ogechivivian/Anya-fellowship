/*
terraform {
  backend "s3" {
    bucket         = ""
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
*/