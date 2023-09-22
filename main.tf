#terraform {
  #backend "remote" {
   # hostname = "app.terraform.io"
    #organization = "Marcoverse"

   # workspaces {
    #  name = "Terrahouse"
   # }
  #}
terraform {
  cloud {
    organization = "Marcoverse"

    workspaces {
      name = "Terrahouse"
    }
  }


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

resource "random_string" "bucket_name" {
  length           = 27
  special          = false
  upper = false
}
#[S3 Resource Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
resource "aws_s3_bucket" "example" {
bucket = random_string.bucket_name.result
  }
#[S3 Naming Conventions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

output "random_bucket_name" {
    value = random_string.bucket_name.result
}