resource "google_compute_vpn_tunnel" "home-lab-tunnel" {
  name                    = "home-lab-tunnel"
  peer_ip                 = var.mikrotik_ip
  shared_secret           = var.tunnel_secret
  remote_traffic_selector = ["192.168.0.0/16"]
  local_traffic_selector  = ["10.25.0.0/16"]

  target_vpn_gateway = google_compute_vpn_gateway.mikrotik_gateway.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}


resource "google_compute_vpn_gateway" "mikrotik_gateway" {
  name    = "vpn-1"
  network = data.google_compute_network.eveng-network.id
}


resource "google_compute_address" "vpn_static_ip" {
  name = "vpn-static-ip"
}



resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.mikrotik_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.mikrotik_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.mikrotik_gateway.id
}

resource "google_compute_route" "route1" {
  name       = "route-to-home-lab"
  network    = data.google_compute_network.eveng-network.name
  dest_range = "192.168.0.0/16"
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.home-lab-tunnel.id
}