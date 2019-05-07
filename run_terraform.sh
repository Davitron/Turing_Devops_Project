#!/usr/bin/env bash

set -e

function run_terraform {
  terraform plan -target module.cluster
  terraform apply -target module.cluster -auto-approve
  gcloud container clusters get-credentials turing
  terraform plan -target module.deployments
  terraform apply -target module.deployments -auto-approve
  gsutil cp terraform.tfstate gs://$BUCKET/$PREFIX/default_tfstate
}

run_terraform