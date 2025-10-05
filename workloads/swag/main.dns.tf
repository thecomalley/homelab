data "http" "onprem_ip" {
  url = "https://ifconfig.me/ip"
}

# External DNS records
resource "cloudflare_dns_record" "external" {
  for_each = toset(var.external_apps)
  zone_id  = var.cloudflare_zone_id
  comment  = "Created by terraform (homelab/clouds/onprem/unRAID/swag)"
  content  = var.swag_external_cname
  name     = each.key
  proxied  = true
  ttl      = 1 # When a DNS record is marked as `proxied` the TTL must be 1 as Cloudflare will control the TTL internally.
  type     = "CNAME"
}

# Internal DNS records
resource "adguard_rewrite" "internal" {
  for_each = toset(concat(var.internal_apps, var.external_apps))
  domain   = "${each.key}.${var.domain_name}"
  answer   = var.swag_internal_ip
}
