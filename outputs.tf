output "tfstate_bucket" {
  description = "Name of the S3 bucket used to store terraform state."
  value       = aws_s3_bucket.terraform_tfstate.id
}

output "tfstate_lock_table" {
  description = "DynamoDB table for the terraform state lock."
  value       = aws_dynamodb_table.terraform_tfstate_lock.id
}

output "account_id" {
  description = "Current account id"
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  description = "ARN of the current user"
  value = data.aws_caller_identity.current.arn
}
