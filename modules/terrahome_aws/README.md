## Terrahome AWS

The following directory 

```tf 
module "home_empires" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.empires_public_path
  assets_path = var.assets_path
}
```

as an example, will have a public directory which expects the following;
- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories