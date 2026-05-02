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
  bucket = "${var.project_name}-bronze-675"

  force_destroy = false

  tags = {
    Environment = "production"
    Project     = var.project_name
    Layer       = "bronze"
    ManagedBy   = "terraform"  
  }
}

resource "aws_s3_bucket_versioning" "bronze_layer_versioning" {
  bucket = aws_s3_bucket.bronze_layer.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "bronze_layer_encryption" {
  bucket = aws_s3_bucket.bronze_layer.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bronze_layer_security" {
  bucket = aws_s3_bucket.bronze_layer.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "silver_layer" {
  bucket = "${var.project_name}-silver-675"

  force_destroy = false

  tags = {
     Environment = "production"
      Project     = var.project_name
      Layer       = "silver"
      ManagedBy   = "terraform"  
  }
}

resource "aws_s3_bucket_versioning" "silver_layer_versioning" {
  bucket = aws_s3_bucket.silver_layer.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "silver_layer_encryption" {
  bucket = aws_s3_bucket.silver_layer.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "silver_layer_security" {
  bucket = aws_s3_bucket.silver_layer.id
  
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "glue_scripts" {
  bucket = "${var.project_name}-scripts-675"

  force_destroy = false

  tags = {
    Environment = "production"
    Project     = var.project_name
    Layer       = "scripts"
    ManagedBy   = "terraform"    
  }
}


resource "aws_s3_bucket_versioning" "glue_scripts_versioning" {
  bucket = aws_s3_bucket.glue_scripts.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "glue_scripts_encryption" {
  bucket = aws_s3_bucket.glue_scripts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "glue_scripts_security" {
  bucket = aws_s3_bucket.glue_scripts.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}




