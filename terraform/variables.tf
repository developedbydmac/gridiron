variable "aws_region" {
  description = "AWS region for provider API calls (AWS Budgets is a global service, but the provider still requires a region)"
  type        = string
  default     = "us-east-1"
}

variable "budget_limit_usd" {
  description = "Monthly AWS spend guardrail, in USD"
  type        = string
  default     = "25"
}

variable "budget_email" {
  description = "Email address that receives budget alert notifications"
  type        = string
}

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
  default     = "gridiron"
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "global"
}

variable "owner" {
  description = "Owner tag applied to all resources"
  type        = string
  default     = "daquan"
}
