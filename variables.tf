#
# Input variable definitions
#

variable "AWS_REGION" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-central-1"
}

variable "PROJECT_ENV" {
  description = "Environment: DEV | TEST | PROD"
  type        = string
  default     = "DEV"
}

data "aws_caller_identity" "current" {}

locals { account_id = data.aws_caller_identity.current.account_id }
