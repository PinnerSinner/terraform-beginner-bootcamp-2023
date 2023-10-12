terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  } 
 # backend "remote" {
  # hostname = "app.terraform.io"
    #organization = "Marcoverse"

   # workspaces {
    #  name = "Terrahouse"
   # }
  #}
  cloud {
    organization = "Marcoverse"

    workspaces {
      name = "Terrahouse"
    }
  }

}
provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_empires_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.empires.public_path
  content_version = var.empires.content_version
}

resource "terratowns_home" "home" {
  name = "Age of Empires"
  description = <<DESCRIPTION
In Age of Empires, you advance through ages. In Terraform, you build your empire within a few commands. Today, in the Age of Terraforming, both my empire and infrastructure as just as likely to collapse! :S 
DESCRIPTION
 domain_name = module.home_empires_hosting.domain_name
  town = "gamers-grotto"
  content_version = var.empires.content_version
}


 module "home_munch_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.munch.public_path
  content_version = var.munch.content_version
}

resource "terratowns_home" "home_munch" {
  name = "British cuisine tops the UK top charts"
  description = <<DESCRIPTION
Right, listen up Terraformers. I've had it up to here with your lazy stereotypes about how British food is boring and tasteless. Let's straighten this out. Lemme show you why British munch is the bee's knees. The cat's pajamas. The dog's b***cks. From jellied eels to spotted dick (yes, you read that right), this TerraHome has it all.
DESCRIPTION
 domain_name = module.home_munch_hosting.domain_name
  town = "cooker-cove"
  content_version = var.munch.content_version
}