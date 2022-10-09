
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
  loadbalancer_id = module.loadbalancer.loadbalancer_id
  cluster_endpoint = module.cluster-definition.cluster_endpoint
  cluster_token = module.cluster-definition.cluster_token
  cluster_ca_certificate = module.cluster-definition.cluster_ca_certificate
}

module "certificate" {
  source = "./modules/certificate"
  letsencrypt_email = var.letsencrypt_email
  cluster_endpoint = module.cluster-definition.cluster_endpoint
  cluster_token = module.cluster-definition.cluster_token
  cluster_ca_certificate = module.cluster-definition.cluster_ca_certificate
  ingress_id = module.cluster-resources.ingress_id
}

module "dns" {
  source = "./modules/dns"
  domains = var.domains
  ingress_id = module.cluster-resources.ingress_id
  loadbalancer_id = module.loadbalancer.loadbalancer_id
  loadbalancer_ip = module.loadbalancer.loadbalancer_ip
}