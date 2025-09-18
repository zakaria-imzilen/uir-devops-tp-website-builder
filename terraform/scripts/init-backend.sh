#!/bin/bash
# init-backend.sh - Initialize GCS backend for Terraform state

set -e

PROJECT_ID=${1}
ENVIRONMENT=${2:-"prod"}

if [ -z "$PROJECT_ID" ]; then
  echo "Usage: $0 <project-id> [environment]"
  echo "Example: $0 my-gcp-project prod"
  exit 1
fi

BUCKET_NAME="${PROJECT_ID}-terraform-state-${ENVIRONMENT}"

echo "🪣 Creating Terraform state bucket: $BUCKET_NAME"

# Create bucket
gcloud storage buckets create gs://$BUCKET_NAME \
  --project=$PROJECT_ID \
  --location=US \
  --uniform-bucket-level-access

# Enable versioning
gcloud storage buckets update gs://$BUCKET_NAME --versioning

echo "✅ Backend bucket created successfully!"
echo "📝 Update envs/$ENVIRONMENT/backend.conf with:"
echo "   bucket = \"$BUCKET_NAME\""
