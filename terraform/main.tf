# main.tf - Root module for GCP Production Infrastructure

provider "google" {
  project = var.project_id
  region  = var.region
}

# Remote state configuration disabled - using local state

# Local values for common configurations
locals {
  environment = "prod"
  app_name    = var.app_name
  common_labels = {
    environment = local.environment
    managed_by  = "terraform"
    app         = local.app_name
  }
}

# Network Module
module "network" {
  source = "./modules/network"
  
  project_id    = var.project_id
  region        = var.region
  environment   = local.environment
  app_name      = local.app_name
  allowed_ssh_ip = var.allowed_ssh_ip
  
  labels = local.common_labels
}

# Artifact Registry Module
module "artifact_registry" {
  source = "./modules/artifact-registry"
  
  project_id  = var.project_id
  region      = var.region
  environment = local.environment
  app_name    = local.app_name
  
  labels = local.common_labels
}

# IAM Module
module "iam" {
  source = "./modules/iam"
  
  project_id  = var.project_id
  environment = local.environment
  app_name    = local.app_name
  
  labels = local.common_labels
}

# Secrets Module
module "secrets" {
  source = "./modules/secrets"
  
  project_id  = var.project_id
  environment = local.environment
  app_name    = local.app_name
  
  labels = local.common_labels
}

# Cloud Run Module
module "cloud_run" {
  source = "./modules/cloud-run"
  
  project_id     = var.project_id
  region         = var.region
  environment    = local.environment
  app_name       = local.app_name
  
  # Dependencies
  vpc_connector_id = module.network.vpc_connector_id
  service_account_email = module.iam.cloud_run_service_account_email
  image_url      = "${module.artifact_registry.repository_url}/${local.app_name}:latest"
  
  # Secrets
  supabase_url_secret    = module.secrets.supabase_url_secret_id
  supabase_key_secret    = module.secrets.supabase_key_secret_id
  app_config_secret      = module.secrets.app_config_secret_id
  
  labels = local.common_labels
}