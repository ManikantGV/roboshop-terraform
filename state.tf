terraform {
  backend "s3" {
    bucket = "mani12-bucket"
    key = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}