resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "waf-policy"
  resource_group_name = var.rg_name
  location            = var.location

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "appgw" {

  name                = "appgw-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.rg_name

  firewall_policy_id = azurerm_web_application_firewall_policy.waf.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

 request_routing_rule {
  name                       = "routing-rule"
  rule_type                  = "Basic"
  http_listener_name         = "listener"
  backend_address_pool_name  = "backend-pool"
  backend_http_settings_name = "http-settings"
  priority                   = 100
}

ssl_policy {

  policy_type = "Predefined"

  policy_name = "AppGwSslPolicy20220101"

}

tags = {
  Environment = "dev"
}
}