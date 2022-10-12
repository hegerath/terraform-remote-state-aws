
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
  default_tags {
    tags = {
      module      = "Terraform"
      environment = "${var.PROJECT_ENV}"
    }
  }
}

# used to store the terraform state
# s3 bucket has to be unique, so account_id is used within the name
resource "aws_s3_bucket" "terraform_tfstate" {
  bucket = "terraform-state-${local.account_id}-${lower(var.PROJECT_ENV)}"
}

# depending on the environment variable PROJECT_ENV (PROD), versioning is enabled
resource "aws_s3_bucket_versioning" "terraform_tfstate" {
  bucket = aws_s3_bucket.terraform_tfstate.id
  # in production set status = Enabled
  versioning_configuration {
    status = var.PROJECT_ENV == "PROD" ? "Enabled" : "Disabled"
  }
}

# used to lock current activities
resource "aws_dynamodb_table" "terraform_tfstate_lock" {
  name         = "terraform-lock-${lower(var.PROJECT_ENV)}"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
  depends_on = [aws_s3_bucket.terraform_tfstate]
}

# every environment has it's own permission set
resource "aws_iam_role" "terraform_role" {
  name = "terraform-role-${lower(var.PROJECT_ENV)}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["s3.amazonaws.com", "dynamodb.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "terraform_s3_policy" {
  name = "terraform-s3-policy-${lower(var.PROJECT_ENV)}"
  role = aws_iam_role.terraform_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "terraform_dynamodb_policy" {
  name = "terraform-dynamodb-policy-${lower(var.PROJECT_ENV)}"
  role = aws_iam_role.terraform_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DescribeTable", "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
