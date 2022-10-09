output "loadbalancer_id" {
  value = digitalocean_loadbalancer.ingress_load_balancer.id
}

output "loadbalancer_ip" {
  value = digitalocean_loadbalancer.ingress_load_balancer.ip
}