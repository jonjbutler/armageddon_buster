terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  region      = "europe-west2"
  zone        = "europe-west2-a"
  project     = "terraform-gcp-1-422404"
  credentials = "terraform-gcp-1-422404-fbcc23b33116.json"
  # Configuration options
}


