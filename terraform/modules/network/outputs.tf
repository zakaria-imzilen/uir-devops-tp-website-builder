# modules/network/outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.main.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.main.name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.main.id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.main.name
}

output "vpc_connector_id" {
  description = "ID of the VPC connector for Cloud Run"
  value       = google_vpc_access_connector.main.id
}

output "vpc_connector_name" {
  description = "Name of the VPC connector"
  value       = google_vpc_access_connector.main.name
}