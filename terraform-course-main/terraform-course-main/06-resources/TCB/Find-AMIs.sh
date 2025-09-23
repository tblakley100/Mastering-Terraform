#!/usr/bin/env zsh
set -euo pipefail

# region used for queries
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-2}
REGION=$AWS_DEFAULT_REGION

echo "Using AWS region: $REGION"
echo "Caller identity:"
aws sts get-caller-identity --output json || { echo "Unable to call STS - check credentials"; exit 1; }

echo
echo "Counting Bitnami NGINX images owned by 379101102735..."
count=$(aws ec2 describe-images \
  --owners 379101102735 \
  --filters "Name=name,Values=bitnami-nginx-*" "Name=architecture,Values=x86_64" \
  --region "$REGION" \
  --query 'length(Images)' --output text)

echo "Found $count images (owner=379101102735, name=bitnami-nginx-*)"

if [ "$count" -eq 0 ]; then
  echo
  echo "No images found under owner 379101102735. Trying a broader search (no owner)..."
  aws ec2 describe-images \
    --filters "Name=name,Values=bitnami-nginx-*" "Name=architecture,Values=x86_64" \
    --region "$REGION" \
    --query 'Images[].{ImageId:ImageId,Name:Name,Owner:OwnerId,Created:CreationDate}' \
    --output table
  exit 0
fi

echo
echo "Most recent Bitnami NGINX image (owner 379101102735):"
aws ec2 describe-images \
  --owners 379101102735 \
  --filters "Name=name,Values=bitnami-nginx-*" "Name=architecture,Values=x86_64" \
  --region "$REGION" \
  --query 'sort_by(Images,&CreationDate)[-1].{ImageId:ImageId,Name:Name,CreationDate:CreationDate,Owner:OwnerId}' \
  --output table