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
