#terraform {
  #backend "remote" {
   # hostname = "app.terraform.io"
    #organization = "Marcoverse"

   # workspaces {
    #  name = "Terrahouse"
   # }
  #}
terraform {
#  cloud {
#    organization = "Marcoverse"
#
#    workspaces {
#      name = "Terrahouse"
#    }
#  }


required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "random" {
  # Configuration options
}
provider "aws" {
  # Configuration options
}
