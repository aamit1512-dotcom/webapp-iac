rgs = {
  dev = {
    name       = "rg-dev-aamit"
    location   = "westus"
    managed_by = null
    tags = {
      env = "dev"
    }
  }
}
nsgs = {
  frontend = {
  name     = "aamit-frontend-nsg"
  rg_name  = "rg-dev-aamit"
  location = "westus"
  tags = { env = "dev" }

  rules = [
    {
      name                        = "allow-ssh"
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"

      destination_port_range      = "22"
      destination_port_ranges     = null

      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },

    {
      name                        = "allow-http"
      priority                    = 101
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"

      destination_port_range      = "80"
      destination_port_ranges     = null

      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },

    {
      name                        = "allow-appgw"
      priority                    = 102
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"

      destination_port_range      = "80"
      destination_port_ranges     = null

      source_address_prefix       = "10.0.0.0/24"  # 👈 App Gateway subnet
      destination_address_prefix  = "*"
    }
  ]
}

  backend = {
    name     = "aamit-backend-nsg"
    rg_name  = "rg-dev-aamit"
    location = "westus"
    tags = { env = "dev" }

    rules = [
      {
        name                        = "allow-frontend"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"

        destination_port_range     = "8080"
        destination_port_ranges    = null

        source_address_prefix      = "10.0.2.0/24"
        destination_address_prefix = "*"
      },
      {
      name                        = "allow-http"
      priority                    = 101
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"

      destination_port_range     = "80"
      destination_port_ranges    = null

      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    ]
  }

  db_subnet = {
    name     = "aamit-db-nsg"
    rg_name  = "rg-dev-aamit"
    location = "westus"
    tags = { env = "dev" }

    rules = [
      {
        name                        = "allow-backend"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"

        destination_port_range     = "1433"
        destination_port_ranges    = null

        source_address_prefix      = "10.0.3.0/24"
        destination_address_prefix = "*"
      }
    ]
  }

 
}


vnets = {
  dev = {
    name     = "vnet-aamit"
    location = "westus"

    rg_name       = "rg-dev-aamit"
    address_space = ["10.0.0.0/16"]

    subnets = {} # ✅ REQUIRED (even if unused here)

    tags = {
      env = "dev"
    }
  }
}

subnets = {

  frontend = {
    name             = "frontend-subnet"
    rg_name          = "rg-dev-aamit"
    vnet_name        = "vnet-aamit"
    address_prefixes = ["10.0.1.0/24"]
    nsg_key          = "frontend"
  }

  backend = {
    name             = "backend-subnet"
    rg_name          = "rg-dev-aamit"
    vnet_name        = "vnet-aamit"
    address_prefixes = ["10.0.2.0/24"]
    nsg_key          = "backend" # SAME NSG reused
  }
  db_subnet = {
    name             = "db-subnet"
    rg_name          = "rg-dev-aamit"
    vnet_name        = "vnet-aamit"
    address_prefixes = ["10.0.3.0/24"]
    nsg_key          = "db_subnet" # SAME NSG reused
  }
  appgw = {
    name             = "gateway-subnet"
    rg_name          = "rg-dev-aamit"
    vnet_name        = "vnet-aamit"
    address_prefixes = ["10.0.4.0/24"]
   nsg_key = null
  }
}
public_ips = {
  frontend = {
    name     = "pip-aamit"
    rg_name  = "rg-dev-aamit"
    location = "westus"

    allocation_method = "Static"
    zones             = ["1", "2"]
    domain_name_label = "app1-dns"
    tags = {
      app = "frontend"
      env = "dev"
    }
  }

  appgw = {
    name              = "pip-aapgw"
    rg_name           = "rg-dev-aamit"
    location          = "westus"
    allocation_method = "Static"
    sku               = "Basic"
    ip_version        = "IPv4"
    tags = {
      app = "backend"
      env = "dev"
    }
  }

}

key_vaults = {
  main = {
    kv_name  = "kv-aamit"
    rg_name  = "rg-dev-aamit"
    location = "westus"

    secrets = {
      school-bus-secret = "55kids"
    }

    tags = {
      env = "dev"
    }
  }
}






storage_accounts = {
  tfstate = {
    resource_group_name      = "rg-dev-aamit"
    location                 = "westus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      environment = "dev"
    }
  }
}

containers = {
  tfstate = {
    name                  = "tfstate"
    container_access_type = "private"
  }
}

administrator_username = "sqladminuser"
administrator_password = "Str0ngP@ssw0rd!"

admin_username      = "azureadmin"
ssh_public_key_path = "C:/Users/aamit/.ssh/id_rsa.pub"

vms = {
  vm1 = {
    vm_name     = "vm-frontend"
    rg_name     = "rg-dev-aamit"
    vnet_name   = "vnet-aamit"
    nic_name    = "nic-frontend"
    vm-username = "azureuseraamit"
    vm-password = "P@ssw0rd1234!"
    location    = "westus"
    size        = "Standard_D2s_v3"
    subnet_key  = "frontend"
    pip_key     = "frontend"

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
  vm2 = {
    vm_name     = "vm-backend"
    rg_name     = "rg-dev-aamit"
    location    = "westus"
    vnet_name   = "vnet-aamit"
    nic_name    = "nic-backend"
    vm-username = "azureuseraamit"
    vm-password = "P@ssw0rd1234!"
    size        = "Standard_D2s_v3"
    subnet_key  = "backend"
    pip_key     = null

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
}