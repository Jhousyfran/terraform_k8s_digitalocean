
module "cluster-definition" {
  source = "./modules/cluster-definition"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  default_node_size = var.default_node_size
  node_count = var.node_count
  region = var.region
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  cluster_name = var.cluster_name
  region = var.region
}

module "cluster-resources" {
  source = "./modules/cluster-resources"
  cluster_name = var.cluster_name
  region = var.region
  domains = var.domains
  letsencrypt_email = var.letsencrypt_email
  loadbalancer_id = module.loadbalancer.loadbalancer_id
}

