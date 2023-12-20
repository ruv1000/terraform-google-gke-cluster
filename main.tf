# provider "google" {
#   # Configuration options
#   project = var.GOOGLE_PROJECT
#   region  = var.GOOGLE_REGION
# }

# module "gke_cluster" {
#   source         = "github.com/ruv1000/tf-google-gke-cluster"
#   GOOGLE_REGION  = var.GOOGLE_REGION
#   GOOGLE_PROJECT = var.GOOGLE_PROJECT
#   GKE_NUM_NODES  = 2
# }

module "github_repository" {
  source = "github.com/ruv1000/tf-github-repository"

  github_owner             = var.github_owner
  github_token             = var.github_token
  repository_name          = var.repository_name
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux"
}

module "tls_private_key" {
  source = "github.com/ruv1000/tf-hashicorp-tls-keys"

  algorithm   = var.algorithm
  ecdsa_curve = var.ecdsa_curve
}

module "tf-kind-cluster" {
  source = "github.com/ruv1000/tf-kind-cluster"

}

module "flux_bootstrap" {
  source = "github.com/ruv1000/tf-fluxcd-flux-bootstrap"

  github_repository = "${var.github_owner}/${var.github_repository}"
  private_key       = module.tls_private_key.private_key_pem
  # config_path       = module.gke_cluster.kubeconfig
  github_token = var.github_token
}
