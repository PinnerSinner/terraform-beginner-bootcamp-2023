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
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}
#provider "terratowns" {
#  index_html_filepath = var.index_html_filepath
#  error_html_filepath = var.error_html_filepath
#  content_version = var.content_version
#}

resource "terratowns_home" "home" {
  name = "Age of Empires"
  description = <<DESCRIPTION
In Age of Empires, you advance through ages. In Terraform, you build your empire within a few commands. Today, in the Age of Terraforming, both my empire and infrastructure as just as likely to collapse! :S 
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}