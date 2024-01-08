# ${path.module} is an interpolated string in Terraform, which references the path to the current
# module. In this case, it returns the path to the directory containing the current module.

# output "kubeconfig" {
#   value       = module.tf-kind-cluster.kubeconfig
#   description = "The path to the kubeconfig file"
# }

output "private_key_pem" {
  value     = module.tls_private_key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value     = module.tls_private_key.public_key_openssh
  sensitive = true
}
