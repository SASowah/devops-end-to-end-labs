/*
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  version    = "45.7.1"  # Check for the latest version

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "grafana.service.type" 
    value = "LoadBalancer"
  }

  set {
    name  = "grafana.adminPassword"
    value = "admin"  # Change this in production
  }
}

# Create Ingress for Grafana (optional)
resource "kubernetes_ingress_v1" "grafana_ingress" {
  depends_on = [helm_release.prometheus]
  metadata {
    name      = "grafana-ingress"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class"                = "alb"
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/grafana"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
*/
