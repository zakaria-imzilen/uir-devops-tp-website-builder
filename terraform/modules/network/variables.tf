# modules/network/variables.tf

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

variable "allowed_ssh_ip" {
  description = "IP address allowed for SSH access (CIDR format)"
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}