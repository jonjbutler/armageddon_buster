resource "google_compute_subnetwork" "NDG1-subnetwork" {
  name          = "no-diddy-subnet"
  ip_cidr_range = "10.2.0.0/24"
  region        = "europe-west2"
  network       = google_compute_network.NDG1-network.id

}

resource "google_compute_network" "NDG1-network" {
  name                    = "no-diddy-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.NDG1-network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["172.16.255.0/24", "172.16.3.0/24", "192.168.10.0/24"]
}

resource "google_compute_network" "default" {
  name = "test-network"
}
# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "no-diddy-gaming-main" {
  boot_disk {
    auto_delete = true
    device_name = "no-diddy-gaming-main"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240415"
      size  = 10
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

  metadata = {
    startup-script = "<html>\n    <head>\n        <title>My First Webpage</title>\n    </head>\n    <body>\n        <h1>NO DIDDY GAMING</h1>\n        <p>\"CAN'T STOP WON'T STOP\"</p>\n    </body>\n\n   <div class=\"tenor-gif-embed\" data-postid=\"956334791911229621\" data-share-method=\"host\" data-aspect-ratio=\"1\" data-width=\"100%\"><a href=\"https://tenor.com/view/p-diddy-the-diddler-puff-daddy-the-riddler-p-diddy-as-the-diddler-gif-956334791911229621\">P Diddy The Diddler GIF</a>from <a href=\"https://tenor.com/search/p+diddy-gifs\">P Diddy GIFs</a></div> <script type=\"text/javascript\" async src=\"https://tenor.com/embed.js\"></script>\n</html>"
  }

  name = "no-diddy-gaming-main"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    network     = google_compute_network.NDG1-network.id
    subnetwork  = google_compute_subnetwork.NDG1-subnetwork.id
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

  zone = "europe-west2-c"
}
