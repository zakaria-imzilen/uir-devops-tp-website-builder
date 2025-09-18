# modules/cloud-run/outputs.tf

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.main.name
}

output "service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_service.main.id
}

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.main.status[0].url
}

output "service_latest_revision" {
  description = "Latest revision name"
  value       = google_cloud_run_service.main.status[0].latest_ready_revision_name
}