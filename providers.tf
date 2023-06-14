terraform {
  required_version = ">=1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.65.2"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "< 5.0"
    }
  }
}

provider "google" {
  project = var.hackathon_project
}