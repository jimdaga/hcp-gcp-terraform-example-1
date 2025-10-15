# Auto-generated Terraform configuration
# Environment: integration
# Region: us-central1
# Sector: e2e
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
provider "google" {
  project = "jimd-gcp-hcp-1"
  region  = "us-central1"
}
# Generate a random suffix for bucket name (must be globally unique)
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
# Create a GCS bucket
resource "google_storage_bucket" "test_bucket" {
  name          = "tekton-test-integration-e2e-${random_id.bucket_suffix.hex}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
  labels = {
    environment = "2e2"
    sector      = "e2e"
    region      = "us-central1"
    created_by  = "tekton"
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}
output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.name
}
output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.test_bucket.url
}
