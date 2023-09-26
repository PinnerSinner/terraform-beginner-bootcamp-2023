terraform {
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

module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name

}