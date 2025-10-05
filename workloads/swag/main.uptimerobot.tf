data "uptimerobot_alert_contact" "pushover" {
  friendly_name = "Pushover"
}

resource "uptimerobot_monitor" "main" {
  for_each      = toset(var.external_apps)
  friendly_name = each.key
  type          = "http"
  url           = "https://${each.key}.${var.domain_name}"

  interval = 300 # Free tier minimum 5 minutes

  alert_contact {
    id = data.uptimerobot_alert_contact.pushover.id
  }
}
