output "plus_nat_ip" {
  description = "NGINX Plus Instance NAT Addresses"
  value       = [google_compute_instance.nginx-plus.*.network_interface.0.access_config.0.nat_ip]
}

output "plus_ip" {
  description = "Local Controller IP Addresses"
  value       = [google_compute_instance.nginx-plus.*.network_interface.0.network_ip]
}