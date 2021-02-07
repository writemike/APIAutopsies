output "controller_nat_ip" {
  description = "Curl command to access Controller"
  value       = "curl -kv https://${google_compute_instance.nginx-controller.network_interface.0.access_config.0.nat_ip}/"
}

output "controller_ip" {
  description = "Local Controller IP Address"
  value       = "curl -kv https://${google_compute_instance.nginx-controller.network_interface.0.network_ip}/"
}