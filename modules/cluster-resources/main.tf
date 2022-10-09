resource "helm_release" "nginx_ingress_chart" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.kubernetes\\.digitalocean\\.com/load-balancer-id"
    value = var.loadbalancer_id
  }

  depends_on = [
    var.loadbalancer_id
  ]

}

resource "kubernetes_ingress_v1" "tfcluster" {
  depends_on = [
    helm_release.nginx_ingress_chart,
  ]
  metadata {
    name = "${var.cluster_name}-ingress"
    namespace  = "default"
    annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "ingress.kubernetes.io/rewrite-target" = "/"
        "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.domains)
      content {
        host = rule.value
        http {
          path {
            backend {
              service {
                name = "${replace(rule.value, ".", "-")}-service"
                port {
                  number = 80
                }
              }
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.domains)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-tls"
        hosts = [tls.value]
      }
    }
  }
}

resource "kubernetes_deployment" "app_deployments" {
  for_each = toset(var.domains)
  metadata {
    name = "${replace(each.value, ".", "-")}-deployment"
    namespace="default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${replace(each.value, ".", "-")}-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app  = "${replace(each.value, ".", "-")}-deployment"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "app-wd"
          port {
            container_port = 80
          }
          resources {
            limits = {
              memory = "512M"
              cpu = "1"
            }
            requests = {
              memory = "256M"
              cpu = "50m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app_services" {
  for_each = toset(var.domains)
  metadata {
    name      = "${replace(each.value, ".", "-")}-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "${replace(each.value, ".", "-")}-deployment"
    }
    port {
      port = 80
    }
  }
}
