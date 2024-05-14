resource "google_compute_network_peering" "peering1" {
  name         = "peering1"
  network      = google_compute_network.NDG-US1-network.id
  peer_network = google_compute_network.NDG1-network.id
}

resource "google_compute_network_peering" "peering2" {
  name         = "peering2"
  network      = google_compute_network.NDG1-network.id
  peer_network = google_compute_network.NDG-US1-network.id
}

#Tunneling:

resource "google_compute_vpn_gateway" "euro-gateway" {
  name    = "euro-gateway-1"
  network = google_compute_network.NDG1-network.id
  region  = "europe-west2"
}

resource "google_compute_address" "vpn_static_euro_ip" {
  name   = "vpn-static-euro-ip-1"
  region = "europe-west2"
}

resource "google_compute_forwarding_rule" "fr_esp-euro-1" {
  name        = "fr-esp-euro-1"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_euro_ip.address
  target      = google_compute_vpn_gateway.euro-gateway.id
  region      = "europe-west2"
}

resource "google_compute_forwarding_rule" "fr_udp500-euro-1" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_euro_ip.address
  target      = google_compute_vpn_gateway.euro-gateway.id
  region      = "europe-west2"
}

resource "google_compute_forwarding_rule" "fr_udp4500-euro-1" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_euro_ip.address
  target      = google_compute_vpn_gateway.euro-gateway.id
  region      = "europe-west2"
}

resource "google_compute_vpn_tunnel" "diddy-euro-tunnel" {
  name                   = "diddys-tunnel"
  peer_ip                = google_compute_address.vpn_static_ip-asia-1.address
  shared_secret          = sensitive("say no to diddy")
  local_traffic_selector = ["10.2.0.0/24"]
  target_vpn_gateway     = google_compute_vpn_gateway.euro-gateway.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp-euro-1,
    google_compute_forwarding_rule.fr_udp4500-euro-1,
    google_compute_forwarding_rule.fr_udp500-euro-1,
  ]
}

resource "google_compute_route" "route1-euro-1" {
  name       = "route1-europe-1"
  network    = google_compute_network.NDG1-network.id
  dest_range = "192.168.10.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.diddy-euro-tunnel.id
  depends_on          = [google_compute_vpn_tunnel.diddy-euro-tunnel]
}

#Tunnel Asia

resource "google_compute_vpn_gateway" "singapore-gateway1" {
  name    = "singapore-vpn-1"
  network = google_compute_network.NDG-asia-network.id
  region  = "asia-southeast1"
}

resource "google_compute_address" "vpn_static_ip-asia-1" {
  name   = "vpn-static-ip-asia-1"
  region = "asia-southeast1"
}

resource "google_compute_forwarding_rule" "fr_esp-asia-1" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip-asia-1.address
  target      = google_compute_vpn_gateway.singapore-gateway1.id
  region      = "asia-southeast1"
}

resource "google_compute_forwarding_rule" "fr_udp500-asia-1" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip-asia-1.address
  target      = google_compute_vpn_gateway.singapore-gateway1.id
  region      = "asia-southeast1"
}

resource "google_compute_forwarding_rule" "fr_udp4500-asia-1" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip-asia-1.address
  target      = google_compute_vpn_gateway.singapore-gateway1.id
  region      = "asia-southeast1"
}

resource "google_compute_vpn_tunnel" "diddy-tunnel-asia" {
  name                   = "diddy-tunnel-asia1"
  peer_ip                = google_compute_address.vpn_static_euro_ip.address
  shared_secret          = sensitive("say no to diddy")
  local_traffic_selector = ["192.168.10.0/24"]
  target_vpn_gateway     = google_compute_vpn_gateway.singapore-gateway1.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp-asia-1,
    google_compute_forwarding_rule.fr_udp500-asia-1,
    google_compute_forwarding_rule.fr_udp4500-asia-1,
  ]
}

resource "google_compute_route" "route-asia-1" {
  name       = "route-asia-1"
  network    = google_compute_network.NDG-asia-network.id
  dest_range = "10.2.0.0/24"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.diddy-tunnel-asia.id
  depends_on          = [google_compute_vpn_tunnel.diddy-tunnel-asia]
}

