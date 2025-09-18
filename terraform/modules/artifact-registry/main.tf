# modules/artifact-registry/main.tf - Docker repository for container images

# Enable Artifact Registry API
resource "google_project_service" "artifact_registry" {
  service = "artifactregistry.googleapis.com"
  
  disable_dependent_services = true
}

# Docker repository
resource "google_artifact_registry_repository" "main" {
  location      = var.region
  repository_id = "${var.app_name}-${var.environment}"
  description   = "Docker repository for ${var.app_name} ${var.environment} environment"
  format        = "DOCKER"

  labels = var.labels

  depends_on = [
    google_project_service.artifact_registry
  ]
}

# IAM binding to allow Cloud Build to push images
resource "google_artifact_registry_repository_iam_member" "cloud_build_writer" {
  project    = var.project_id
  location   = google_artifact_registry_repository.main.location
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.project_id}@cloudbuild.gserviceaccount.com"
}

# IAM binding for the deploy service account (if using separate CI/CD)
resource "google_artifact_registry_repository_iam_member" "deploy_reader" {
  count      = var.deploy_service_account_email != "" ? 1 : 0
  project    = var.project_id
  location   = google_artifact_registry_repository.main.location
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.deploy_service_account_email}"
}