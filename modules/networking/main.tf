

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  tags                = try(each.value.tags, {})
dynamic "security_rule" {
  for_each = each.value.rules

  content {
    name                        = security_rule.value.name
    priority                    = security_rule.value.priority
    direction                   = security_rule.value.direction
    access                      = security_rule.value.access
    protocol                    = security_rule.value.protocol
    source_port_range           = security_rule.value.source_port_range
    source_address_prefix       = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix

    destination_port_range  = security_rule.value.destination_port_range
    destination_port_ranges = security_rule.value.destination_port_ranges
  }
}
}



resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
}



 resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
   depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_group" "appgw" {
  name                = "aamit-gateway-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "Allow-HTTP-HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges   = ["80", "443"]
    source_address_prefix     = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-AppGateway-Infra"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges   = ["65200-65535"]
    source_address_prefix     = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Azure-LB"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range    = "*"
    source_address_prefix     = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
  for k, v in var.subnets :
  k => v if v.nsg_key != null
}

  subnet_id = azurerm_subnet.subnet[each.key].id

  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_key].id
}
resource "azurerm_subnet_network_security_group_association" "appgw_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet["appgw"].id
  network_security_group_id = azurerm_network_security_group.appgw.id
}