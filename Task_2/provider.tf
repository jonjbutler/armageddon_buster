terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.28.0"
    }
  }
}

provider "google" {
  region      = "asia-southeast1"
  zone        = "asia-southeast1-a"
  project     = "network-255-419904"
  credentials = "network-255-419904-bbdfd1b6ced3.json"
  # Configuration options
}

