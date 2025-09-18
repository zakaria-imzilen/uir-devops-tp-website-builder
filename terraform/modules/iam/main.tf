# modules/iam/main.tf - Service accounts and IAM policies

# Service account for Cloud Run service
resource "google_service_account" "cloud_run" {
  account_id   = "${var.app_name}-${var.environment}-run"
  display_name = "Cloud Run service account for ${var.app_name} ${var.environment}"
  description  = "Service account used by Cloud Run service to access GCP resources"
}

# Service account for deployment/CI-CD
resource "google_service_account" "deploy" {
  account_id   = "${var.app_name}-${var.environment}-deploy"
  display_name = "Deploy service account for ${var.app_name} ${var.environment}"
  description  = "Service account used for deploying applications and managing infrastructure"
}

# IAM roles for Cloud Run service account
resource "google_project_iam_member" "cloud_run_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_trace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Secret Manager access for Cloud Run
resource "google_project_iam_member" "cloud_run_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# IAM roles for deploy service account (least privilege for CI/CD)
resource "google_project_iam_member" "deploy_cloud_run_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

resource "google_project_iam_member" "deploy_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

resource "google_project_iam_member" "deploy_cloud_build" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

resource "google_project_iam_member" "deploy_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

resource "google_project_iam_member" "deploy_iam_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

# Secret Manager admin for deploy service account (to manage secrets)
resource "google_project_iam_member" "deploy_secret_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.deploy.email}"
}

# Allow deploy service account to act as Cloud Run service account
resource "google_service_account_iam_member" "deploy_impersonate_cloud_run" {
  service_account_id = google_service_account.cloud_run.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.deploy.email}"
}

# Create service account keys (optional, for local development)
resource "google_service_account_key" "deploy_key" {
  count              = var.create_service_account_keys ? 1 : 0
  service_account_id = google_service_account.deploy.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}