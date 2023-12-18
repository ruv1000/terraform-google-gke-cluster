provider "google" {
  # Configuration options
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

terraform {
  backend "gcs" {
    bucket = "tf-state-cluster-gke"
    prefix = "terraform/state"
  }
}

module "gke_cluster" {
  source         = "github.com/ruv1000/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}
