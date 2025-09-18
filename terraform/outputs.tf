# outputs.tf - Output values from the infrastructure

output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = module.cloud_run.service_url
}

output "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  value       = module.cloud_run.service_name
}

output "artifact_registry_url" {
  description = "URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_url
}

output "service_account_emails" {
  description = "Email addresses of created service accounts"
  value = {
    cloud_run = module.iam.cloud_run_service_account_email
    deploy    = module.iam.deploy_service_account_email
  }
}

output "secret_names" {
  description = "Names of created secrets in Secret Manager"
  value = {
    supabase_url    = module.secrets.supabase_url_secret_name
    supabase_key    = module.secrets.supabase_key_secret_name
    app_config      = module.secrets.app_config_secret_name
  }
}

output "secret_ids" {
  description = "Full resource IDs of created secrets"
  value = {
    supabase_url    = module.secrets.supabase_url_secret_id
    supabase_key    = module.secrets.supabase_key_secret_id
    app_config      = module.secrets.app_config_secret_id
  }
}

output "vpc_name" {
  description = "Name of the created VPC"
  value       = module.network.vpc_name
}

output "subnet_name" {
  description = "Name of the created subnet"
  value       = module.network.subnet_name
}

output "project_id" {
  description = "GCP Project ID used"
  value       = var.project_id
}

output "region" {
  description = "GCP Region used"
  value       = var.region
}