terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Local state for now. Migrates to an S3 backend with locking in Sprint 2
  # (GRID roadmap: "Terraform remote state in S3").
}
