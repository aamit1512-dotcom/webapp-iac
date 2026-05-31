resource_groups = {

  backend = {

    name     = "rg-terraform-state"

    location = "westus"

    tags = {

      environment = "backend"

    }

  }

}

storage_accounts = {

  tfstate = {

    resource_group_name      = "rg-terraform-state"

    location                 = "westus"

    account_tier             = "Standard"

    account_replication_type = "LRS"

    tags = {

      environment = "backend"

    }

  }

}

containers = {

  tfstate = {

    name                  = "tfstate"

    container_access_type = "private"

  }

}