# modules/secrets/main.tf - Secret Manager resources for application secrets

# Enable Secret Manager API
resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  
  disable_dependent_services = true
}

# Supabase URL secret
resource "google_secret_manager_secret" "supabase_url" {
  secret_id = "${var.app_name}-${var.environment}-supabase-url"
  
  labels = merge(var.labels, {
    type = "supabase-config"
  })
  
  replication {
    auto {}
  }
  
  depends_on = [
    google_project_service.secret_manager
  ]
}

# Supabase URL secret version (placeholder - to be updated with actual value)
resource "google_secret_manager_secret_version" "supabase_url" {
  secret      = google_secret_manager_secret.supabase_url.id
  secret_data = var.supabase_url != "" ? var.supabase_url : "https://your-project.supabase.co"
}

# Supabase API Key secret
resource "google_secret_manager_secret" "supabase_key" {
  secret_id = "${var.app_name}-${var.environment}-supabase-key"
  
  labels = merge(var.labels, {
    type = "supabase-config"
  })
  
  replication {
    auto {}
  }
  
  depends_on = [
    google_project_service.secret_manager
  ]
}

# Supabase API Key secret version (placeholder - to be updated with actual value)
resource "google_secret_manager_secret_version" "supabase_key" {
  secret      = google_secret_manager_secret.supabase_key.id
  secret_data = var.supabase_key != "" ? var.supabase_key : "your-supabase-anon-key-here"
}

# App configuration secret (for environment variables)
resource "google_secret_manager_secret" "app_config" {
  secret_id = "${var.app_name}-${var.environment}-app-config"
  
  labels = merge(var.labels, {
    type = "app-config"
  })
  
  replication {
    auto {}
  }
  
  depends_on = [
    google_project_service.secret_manager
  ]
}

# App configuration secret version (JSON format for multiple config values)
resource "google_secret_manager_secret_version" "app_config" {
  secret = google_secret_manager_secret.app_config.id
  secret_data = jsonencode({
    NODE_ENV    = var.environment
    PORT        = var.app_port
    LOG_LEVEL   = var.log_level
    DATABASE_URL = "placeholder"
    REDIS_URL   = "placeholder"
  })
}