data "http" "onprem_ip" {
  url = "https://ifconfig.me/ip"
}

resource "cloudflare_dns_record" "a" {
  for_each = toset(var.apps)

  zone_id = var.cloudflare_zone_id
  comment = "Created by terraform/swag"
  content = data.http.onprem_ip.response_body
  name    = each.key
  proxied = true
  ttl     = 1 # When a DNS record is marked as `proxied` the TTL must be 1 as Cloudflare will control the TTL internally.
  type    = "A"
}
