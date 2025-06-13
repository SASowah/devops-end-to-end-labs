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
/*
data "kubernetes_service" "grafana" {
  metadata {
    name      = "prometheus-grafana"
    namespace = "monitoring"
  }
  depends_on = [helm_release.prometheus]
}

output "grafana_endpoint" {
  description = "Endpoint for Grafana dashboard"
  value       = try("http://${data.kubernetes_service.grafana.status.0.load_balancer.0.ingress.0.hostname}:80", "Grafana endpoint not available yet")
  depends_on  = [helm_release.prometheus]
}

output "grafana_admin_password" {
  description = "Admin password for Grafana"
  value       = "admin"  # Change this if you modified it
  sensitive   = true
}

output "grafana_port_forward_command" {
  description = "Command to port forward Grafana to localhost"
  value       = "kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
}
*/
