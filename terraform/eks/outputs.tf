output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

/*output "kubeconfig" {
  description = "EKS kubeconfig"
  value       = module.eks.kubeconfig
}*/

output "region" {
  value = var.aws_region
}
