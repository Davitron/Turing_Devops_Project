#!/usr/bin/env bash

set -e

function run_terraform {
  touch terrform-init
  echo "bucket=\"$BUCKET\"" >> terraform-init
  echo "prefix=\"$PREFIX\"" >> terraform-init
  echo "credentials=\"$CREDENTIALS_FILE\"" >> terraform-init
  terraform init --backend-config=terraform-init
  terraform plan -target module.cluster
  terraform apply -target module.cluster -auto-approve
  gcloud container clusters get-credentials turing
  terraform plan -target module.deployments
  terraform apply -target module.deployments -auto-approve
}

run_terraform