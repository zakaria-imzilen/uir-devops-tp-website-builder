# GCP Terraform Infrastructure

This repository contains Terraform Infrastructure as Code (IaC) for deploying applications to Google Cloud Platform.

## Architecture

- **VPC**: Custom network with single subnet and NAT gateway
- **Cloud Run**: Serverless container platform for the application
- **Artifact Registry**: Docker container registry
- **Secret Manager**: Secure storage for application secrets
- **IAM**: Least-privilege service accounts
- **Monitoring**: Cloud Logging and Monitoring enabled

## Quick Start

1. **Prerequisites**
   - Install [Terraform](https://www.terraform.io/downloads.html) >= 1.5
   - Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
   - Authenticate: `gcloud auth application-default login`

2. **Setup**
   ```bash
   # Clone and setup
   git clone <your-repo>
   cd gcp-terraform-infra
   
   # Copy and customize variables
   cp terraform.tfvars.example envs/prod/terraform.tfvars
   # Edit envs/prod/terraform.tfvars with your values
   ```

3. **Create State Bucket** (one-time setup)
   ```bash
   # Replace with your project ID and desired bucket name
   export PROJECT_ID="your-project-id"
   export STATE_BUCKET="${PROJECT_ID}-terraform-state"
   
   gsutil mb -p $PROJECT_ID gs://$STATE_BUCKET
   gsutil versioning set on gs://$STATE_BUCKET
   
   # Update backend.conf files with your bucket name
   ```

4. **Deploy**
   ```bash
   cd envs/prod
   terraform init -backend-config=backend.conf
   terraform plan -var-file=terraform.tfvars
   terraform apply -var-file=terraform.tfvars
   ```

## Project Structure

See [PROJECT_STRUCTURE.md] for detailed folder organization.

## Outputs

After successful deployment, you'll get:
- Cloud Run service URL
- Service account emails
- Secret Manager secret names
- Artifact Registry repository URL

## Environment Management

Each environment (prod/staging/dev) has its own:
- Variable files (`terraform.tfvars`)
- Backend configuration (`backend.conf`)
- Terraform state (separate GCS buckets recommended)

## Security

- Service accounts use least-privilege IAM roles
- Secrets stored in Secret Manager
- Network access restricted to necessary ports
- SSH access limited to specified IP ranges

## CI/CD Integration

- GitHub Actions workflows for automated deployment
- Jenkins pipeline files included
- Plan on PR, apply on merge to main

## Support

For issues or questions, please create an issue in this repository.
