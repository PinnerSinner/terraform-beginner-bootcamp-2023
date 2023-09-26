# Terraform Bootcamp - Week 1

## Root Module Structure
Our root module structure is as follows: 
```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kind of variables:
- Enviroment Variables - These are set in your Bash terminal, such as AWS credentials.
- Terraform Variables - Typically defined in tfvars files.

We can mark Terraform Cloud variables as sensitive to keep them hidden in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag

The `var-file` flag allows you to specify a tfvars file that contains variable definitions. it's useful when you have multiple variable files. 
For example, `terraform apply -var-file=my-variables.tfvars`

### terraform.tvfars

This is the default file for loading Terraform variables locally. Variables defined in this file will be automatically picked up by Terraform. 

### auto.tfvars

In Terraform Cloud, `auto.tfvars` is automatically loaded if present. You can use it to specify variables without needing to explicitly mention the `-var-file` flag

### order of terraform variables

Terraform follows a specific order when resolving variables values:
1 - Environment variables
2 - The `var` and `-var-file` flags
3 - Variables defined in `auto.tfvars`
4 - Variables defined in `terraform.tfvars`
It's to prioritise variables sources accordingly to avoid conflict and make sure that the right variable values are used accordingly. 