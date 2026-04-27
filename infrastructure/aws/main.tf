terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "BUCKET NAME"
    key            = "aws/terraform.tfstate"
    region         = "REGION NAME"
    encrypt        = true
    dynamodb_table = "TABLE NAME" 

  }
}


provider "aws" {
    region = var.region
    assume_role {
    role_arn     = var.assume_role_arn
    session_name = var.assume_role_session
}
}

resource "aws_s3_bucket" "bronze_layer" {
  bucket = "${var.project_name}_bronze_675"

  force_destroy = false

  tags = {
    
  }
}