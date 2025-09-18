# modules/cloud-run/variables.tf

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, staging, dev)"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "image_url" {
  description = "Container image URL"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account to run as"
  type        = string
}

variable "vpc_connector_id" {
  description = "ID of the VPC connector"
  type        = string
}

variable "supabase_url_secret" {
  description = "Secret Manager secret ID for Supabase URL"
  type        = string
}

variable "supabase_key_secret" {
  description = "Secret Manager secret ID for Supabase key"
  type        = string
}

variable "app_config_secret" {
  description = "Secret Manager secret ID for app config"
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "cpu_limit" {
  description = "CPU limit per instance"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit per instance"
  type        = string
  default     = "512Mi"
}

variable "container_concurrency" {
  description = "Maximum concurrent requests per instance"
  type        = number
  default     = 1000
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

variable "allow_public_access" {
  description = "Allow public (unauthenticated) access to the service"
  type        = bool
  default     = true
}

variable "allow_authenticated_access" {
  description = "Allow authenticated users access to the service"
  type        = bool
  default     = false
}