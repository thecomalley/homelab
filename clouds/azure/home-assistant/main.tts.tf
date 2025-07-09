resource "azurerm_cognitive_account" "hass" {
  name                = "oma-hass-prd-aue-tts-cog"
  resource_group_name = azurerm_resource_group.hass.name
  location            = "swedencentral"
  kind                = "SpeechServices"
  sku_name            = "S0"
  tags = merge({
    "Component"     = "Microsoft Text-to-Speech (TTS)"
    "Documentation" = "https://www.home-assistant.io/integrations/microsoft/"
  }, local.tags)
}
