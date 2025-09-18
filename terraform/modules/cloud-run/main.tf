# modules/cloud-run/main.tf - Cloud Run service for the application

# Enable required APIs
resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
  
  disable_dependent_services = true
}

resource "google_project_service" "cloud_build" {
  service = "cloudbuild.googleapis.com"
  
  disable_dependent_services = true
}

# Cloud Run service
resource "google_cloud_run_service" "main" {
  name     = "${var.app_name}-${var.environment}"
  location = var.region

  template {
    metadata {
      labels = var.labels
      annotations = {
        "autoscaling.knative.dev/minScale" = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector_id
        "run.googleapis.com/vpc-access-egress" = "all-traffic"
        "run.googleapis.com/execution-environment" = "gen2"
      }
    }

    spec {
      service_account_name = var.service_account_email
      
      containers {
        image = var.image_url

        # Resource limits
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }

        # Environment variables from secrets
        env {
          name = "SUPABASE_URL"
          value_from {
            secret_key_ref {
              name = var.supabase_url_secret
              key  = "latest"
            }
          }
        }

        env {
          name = "SUPABASE_ANON_KEY"
          value_from {
            secret_key_ref {
              name = var.supabase_key_secret
              key  = "latest"
            }
          }
        }

        # App config from JSON secret
        env {
          name = "NODE_ENV"
          value_from {
            secret_key_ref {
              name = var.app_config_secret
              key  = "latest"
            }
          }
        }

        # Additional environment variables
        env {
          name  = "PORT"
          value = "8080"
        }

        env {
          name  = "GOOGLE_CLOUD_PROJECT"
          value = var.project_id
        }

        # Health check port
        ports {
          container_port = 8080
        }

        # Liveness probe
        liveness_probe {
          http_get {
            path = "/health"
            port = 8080
          }
          initial_delay_seconds = 30
          period_seconds        = 10
          timeout_seconds       = 5
          failure_threshold     = 3
        }

        # Startup probe
        startup_probe {
          http_get {
            path = "/health"
            port = 8080
          }
          initial_delay_seconds = 10
          period_seconds        = 5
          timeout_seconds       = 5
          failure_threshold     = 10
        }
      }

      # Container concurrency
      container_concurrency = var.container_concurrency
      timeout_seconds      = var.timeout_seconds
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.cloud_run
  ]
}

# IAM policy for public access (if needed)
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_public_access ? 1 : 0
  
  location = google_cloud_run_service.main.location
  project  = var.project_id
  service  = google_cloud_run_service.main.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# IAM policy for authenticated access
resource "google_cloud_run_service_iam_member" "authenticated_access" {
  count = var.allow_authenticated_access ? 1 : 0
  
  location = google_cloud_run_service.main.location
  project  = var.project_id
  service  = google_cloud_run_service.main.name
  role     = "roles/run.invoker"
  member   = "allAuthenticatedUsers"
}