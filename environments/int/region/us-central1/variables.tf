  variable "environment" {
    description = "Deployment environment"
    type        = string
    default     = "integration"
  }

  variable "region" {
    description = "GCP region"
    type        = string
    default     = "us-central1"
  }

  variable "sector" {
    description = "Deployment sector"
    type        = string
    default     = "e2e"
  }
