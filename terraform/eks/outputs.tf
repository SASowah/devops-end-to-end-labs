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

# Add to outputs.tf
output "grafana_endpoint" {
  description = "Endpoint for Grafana dashboard"
  value       = kubernetes_ingress_v1.grafana_ingress.status.0.load_balancer.0.ingress.0.hostname
}

output "grafana_admin_password" {
  description = "Admin password for Grafana"
  value       = "admin"  # Change this if you modified it
  sensitive   = true
}