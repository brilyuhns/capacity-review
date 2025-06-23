#!/usr/bin/env bash
# Deploy the Capacity Review app to Google Cloud Run
set -euo pipefail

PROJECT_ID=$(gcloud config get-value project)
REGION=${REGION:-us-central1}
SERVICE_NAME=${SERVICE_NAME:-capacity-review}
BUCKET=${BUCKET:-$PROJECT_ID-capacity-review-db}
IMAGE=gcr.io/$PROJECT_ID/$SERVICE_NAME

# Create bucket if it does not exist
if ! gsutil ls -b gs://$BUCKET >/dev/null 2>&1; then
  gsutil mb -p $PROJECT_ID gs://$BUCKET
fi

# Build and push the container
gcloud builds submit --tag $IMAGE

# Deploy to Cloud Run with the bucket mounted
gcloud run deploy $SERVICE_NAME \
  --image $IMAGE \
  --region $REGION \
  --platform managed \
  --allow-unauthenticated \
  --add-volume name=db,google-cloud-storage-bucket=$BUCKET \
  --add-volume-mount volume=db,mount-path=/gcs \
  --set-env-vars GCS_BUCKET=$BUCKET
