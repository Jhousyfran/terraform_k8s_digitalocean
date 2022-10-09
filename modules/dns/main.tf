resource "digitalocean_domain" "domains" {
    for_each = toset(var.domains)
    name = each.value
}

resource "digitalocean_record" "a_records" {
  for_each = toset(var.domains)
  domain = each.value
  type   = "A"
  ttl = 60
  name   = "@"
  value  = var.loadbalancer_ip
  depends_on = [
    digitalocean_domain.domains,
    var.ingress_id
  ]
}

resource "digitalocean_record" "cname_redirects" {
  for_each = toset(var.domains)
  domain = each.value
  type   = "CNAME"
  ttl = 60
  name   = "www"
  value  = "@"
  depends_on = [
    digitalocean_domain.domains
  ]
}
