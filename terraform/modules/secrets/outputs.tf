# modules/secrets/outputs.tf

output "supabase_url_secret_id" {
  description = "ID of the Supabase URL secret"
  value       = google_secret_manager_secret.supabase_url.id
}

output "supabase_url_secret_name" {
  description = "Name of the Supabase URL secret"
  value       = google_secret_manager_secret.supabase_url.secret_id
}

output "supabase_key_secret_id" {
  description = "ID of the Supabase key secret"
  value       = google_secret_manager_secret.supabase_key.id
}

output "supabase_key_secret_name" {
  description = "Name of the Supabase key secret"
  value       = google_secret_manager_secret.supabase_key.secret_id
}

output "app_config_secret_id" {
  description = "ID of the app config secret"
  value       = google_secret_manager_secret.app_config.id
}

output "app_config_secret_name" {
  description = "Name of the app config secret"
  value       = google_secret_manager_secret.app_config.secret_id
}