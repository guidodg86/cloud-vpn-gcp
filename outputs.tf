output "gcp_tunnel_ip" {
  description = "Public ip for tunnel endpoint"
  value       = google_compute_address.vpn_static_ip.address
}