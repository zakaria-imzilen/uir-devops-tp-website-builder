# modules/iam/outputs.tf

output "cloud_run_service_account_email" {
  description = "Email of the Cloud Run service account"
  value       = google_service_account.cloud_run.email
}

output "cloud_run_service_account_id" {
  description = "ID of the Cloud Run service account"
  value       = google_service_account.cloud_run.id
}

output "deploy_service_account_email" {
  description = "Email of the deploy service account"
  value       = google_service_account.deploy.email
}

output "deploy_service_account_id" {
  description = "ID of the deploy service account"
  value       = google_service_account.deploy.id
}

output "deploy_service_account_key" {
  description = "Private key for deploy service account (if created)"
  value       = var.create_service_account_keys ? google_service_account_key.deploy_key[0].private_key : ""
  sensitive   = true
}