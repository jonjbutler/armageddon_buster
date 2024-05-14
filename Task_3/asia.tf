resource "google_compute_subnetwork" "NDG-asia-subnetwork" {
  name          = "no-diddy-asia-sub"
  ip_cidr_range = "192.168.10.0/24"
  region        = "asia-southeast1"
  network       = google_compute_network.NDG-asia-network.id

}

resource "google_compute_network" "NDG-asia-network" {
  name                    = "no-diddy-asia-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "diddy-party-asia" {
  name    = "diddy-party-asia"
  network = google_compute_network.NDG-asia-network.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_instance" "no-diddy-asia" {
  boot_disk {
    auto_delete = true
    device_name = "no-diddy-asia"

    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
      size  = 50
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  name         = "no-diddy-asia"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/terraform-gcp-1-422404/regions/asia-southeast1/subnetworks/no-diddy-asia-sub"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "998349790549-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "asia-southeast1-b"
}
