
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
}

resource "digitalocean_kubernetes_cluster" "tfcluster" {
  name   = var.cluster_name
  region = var.region
  version = var.cluster_version

  node_pool {
    name       = "${var.cluster_name}-worker-pool"
    size       = var.default_node_size
    node_count = var.node_count
  }
}
