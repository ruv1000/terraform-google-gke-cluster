terraform {
  backend "gcs" {
    bucket = "tf-state-cluster-gke"
    prefix = "terraform/state"
  }
}
