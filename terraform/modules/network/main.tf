# modules/network/main.tf - VPC and networking resources

# VPC
resource "google_compute_network" "main" {
  name                    = "${var.app_name}-${var.environment}-vpc"
  auto_create_subnetworks = false
  routing_mode           = "GLOBAL"
  
  depends_on = [
    google_project_service.compute
  ]
}

# Subnet
resource "google_compute_subnetwork" "main" {
  name          = "${var.app_name}-${var.environment}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.main.id
  
  # Enable private Google access for resources without external IPs
  private_ip_google_access = true
  
  # Secondary ranges for GKE if needed in future
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }
  
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/20"
  }
}

# Cloud Router for NAT Gateway
resource "google_compute_router" "main" {
  name    = "${var.app_name}-${var.environment}-router"
  region  = var.region
  network = google_compute_network.main.id
}

# NAT Gateway for outbound internet access
resource "google_compute_router_nat" "main" {
  name   = "${var.app_name}-${var.environment}-nat"
  router = google_compute_router.main.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall Rules
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.app_name}-${var.environment}-allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [var.allowed_ssh_ip]
  target_tags   = ["ssh-allowed"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "${var.app_name}-${var.environment}-allow-http"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.app_name}-${var.environment}-allow-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["443", "8443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.app_name}-${var.environment}-allow-internal"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/8"]
}

# VPC Connector for Cloud Run
resource "google_vpc_access_connector" "main" {
  name          = "${var.app_name}-${var.environment}-connector"
  region        = var.region
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.main.name
  
  depends_on = [
    google_project_service.vpcaccess
  ]
}

# Enable required APIs
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  
  disable_dependent_services = true
}

resource "google_project_service" "vpcaccess" {
  service = "vpcaccess.googleapis.com"
  
  disable_dependent_services = true
}