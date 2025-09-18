# modules/secrets/variables.tf

variable "project_id" {
  description = "GCP Project ID"
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

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "supabase_url" {
  description = "Supabase project URL"
  type        = string
  default     = ""
}

variable "supabase_key" {
  description = "Supabase anon key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "app_port" {
  description = "Application port"
  type        = string
  default     = "8080"
}

variable "log_level" {
  description = "Application log level"
  type        = string
  default     = "info"
}