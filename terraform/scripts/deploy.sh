#!/bin/bash
# deploy.sh - Deploy to specified environment

set -e

ENVIRONMENT=${1:-"prod"}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_DIR/envs/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
  echo "❌ Environment '$ENVIRONMENT' not found"
  exit 1
fi

echo "🚀 Deploying to $ENVIRONMENT environment..."

cd "$ENV_DIR"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
  echo "❌ terraform.tfvars not found in $ENV_DIR"
  echo "💡 Copy from terraform.tfvars.template and customize"
  exit 1
fi

# Initialize if needed
if [ ! -d ".terraform" ]; then
  echo "🔧 Initializing Terraform..."
  terraform init -backend-config=backend.conf
fi

# Plan
echo "📋 Planning deployment..."
terraform plan -var-file=terraform.tfvars

# Confirm before applying
read -p "🤔 Apply these changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "✅ Applying changes..."
  terraform apply -var-file=terraform.tfvars
  
  echo "🎉 Deployment complete!"
  echo "📊 Outputs:"
  terraform output
else
  echo "❌ Deployment cancelled"
fi
