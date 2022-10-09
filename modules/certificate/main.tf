# cert-manager resources

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.0.1"
  namespace        = "kube-system"
  timeout          = 120

  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name = "installCRDs"
    value = "true"
  }

  depends_on = [
    var.ingress_id
  ]
  
}

resource "helm_release" "cluster-issuer" {
  name      = "cluster-issuer"
  chart     = "./helm_charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    helm_release.cert-manager,
  ]
  set {
    name  = "letsencrypt_email"
    value = "${var.letsencrypt_email}"
  }
}
