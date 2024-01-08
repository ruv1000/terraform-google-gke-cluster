provider "google" {
  # Configuration options
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

module "gke_cluster" {
  source         = "github.com/ruv1000/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}

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

# module "tf-kind-cluster" {
#   source = "github.com/ruv1000/tf-kind-cluster"
# }

module "flux_bootstrap" {
  source = "github.com/ruv1000/tf-fluxcd-flux-bootstrap"

  github_repository = "${var.github_owner}/${var.github_repository}"
  private_key       = module.tls_private_key.private_key_pem
  config_path       = "~/.kube/config" # module.gke_cluster.kubeconfig
  github_token      = var.github_token
}

module "gke-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  name                = "kustomize-controller"
  namespace           = "flux-system"
  project_id          = var.GOOGLE_PROJECT
  cluster_name        = "main"
  location            = var.GOOGLE_REGION
  annotate_k8s_sa     = true
  roles               = ["roles/cloudkms.cryptoKeyEncrypterDecrypter"]
}

module "kms" {
  source          = "github.com/ruv1000/terraform-google-kms"
  project_id      = var.GOOGLE_PROJECT
  keyring         = "sops-flux"
  location        = "global"
  keys            = ["sops-key-flux"]
  prevent_destroy = false

}
