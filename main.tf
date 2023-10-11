terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  } 
  #backend "remote" {
   # hostname = "app.terraform.io"
    #organization = "Marcoverse"

   # workspaces {
    #  name = "Terrahouse"
   # }
  #}
#  cloud {
#    organization = "Marcoverse"
#
#    workspaces {
#      name = "Terrahouse"
#    }
#  }

}
provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Age of Empires"
  description = <<DESCRIPTION
In Age of Empires, you advance through ages. In Terraform, you build your empire within a few commands. Today, in the Age of Terraforming, both my empire and infrastructure as just as likely to collapse! :S 
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  #town = "gamers-grotto"
  town = "missingo"
  content_version = 1
}