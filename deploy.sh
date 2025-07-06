#!/usr/bin/env bash
# Deploy the Capacity Review app to Google Cloud Run
set -euo pipefail

PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID: $PROJECT_ID"
REGION=${REGION:-asia-southeast1}
echo "REGION: $REGION"
SERVICE_NAME=${SERVICE_NAME:-capacity-review}
echo "SERVICE_NAME: $SERVICE_NAME"
BUCKET=${BUCKET:-$PROJECT_ID-capacity-review-db}
echo "BUCKET: $BUCKET"
REPOSITORY=${REPOSITORY:-capacity-review-repo}
echo "REPOSITORY: $REPOSITORY"
IMAGE=$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$SERVICE_NAME
echo "IMAGE: $IMAGE"

# Create Artifact Registry repository if it doesn't exist
if ! gcloud artifacts repositories describe $REPOSITORY --location=$REGION >/dev/null 2>&1; then
  echo "Creating Artifact Registry repository: $REPOSITORY"
  gcloud artifacts repositories create $REPOSITORY \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository for Capacity Review app"
fi

# Create bucket if it does not exist
if ! gsutil ls -b gs://$BUCKET >/dev/null 2>&1; then
  gsutil mb -p $PROJECT_ID gs://$BUCKET
fi

# # Build and push the container
gcloud builds submit --config cloudbuild.yaml --substitutions _IMAGE_NAME=$IMAGE

# # Deploy to Cloud Run with the bucket mounted
gcloud run deploy $SERVICE_NAME \
  --image $IMAGE \
  --region $REGION \
  --platform managed \
  --allow-unauthenticated \
  --add-volume name=db,type=cloud-storage,bucket=$BUCKET \
  --add-volume-mount volume=db,mount-path=/gcs \
  --set-env-vars GCS_BUCKET=$BUCKET
