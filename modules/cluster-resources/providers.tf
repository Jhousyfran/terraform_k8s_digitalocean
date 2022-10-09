terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  host    = var.cluster_endpoint
  token   = var.cluster_token
  cluster_ca_certificate = base64decode(
    var.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = var.cluster_endpoint
    token = var.cluster_token
    cluster_ca_certificate = base64decode(
      var.cluster_ca_certificate
    )
  }
}