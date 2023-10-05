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

## Dealing With Configuration Drift
- Configuration drift can occur when the actual state of your cloud resources differs from the expected state defined in your Terraform configuration. This can happen for various reasons, including manual changes made outside of Terraform. Here's how to address configuration drift:
## What happens if we lose our state file?

-Losing your Terraform state file can be problematic as it's essential for tracking and managing your infrastructure. 
If you lose your state file, you may need to manually tear down your cloud infrastructure. However, there are some strategies to help recover from this situation.

### Fix Missing Resources with Terraform Import

- You can use Terraform's import functionality to bring existing cloud resources under Terraform's management. This can be useful for resources not initially managed by Terraform or when recovering from a lost state file.

- For example, to import an existing AWS S3 bucket into your Terraform configuration, you can use the following command:
`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration
- If someone manually modifies cloud resources outside of Terraform, such as through a graphical interface (ClickOps), your infrastructure may drift from its expected state. To reconcile this drift, you can use Terraform.

R- unning terraform plan will identify differences between your Terraform configuration and the actual infrastructure. It will propose changes needed to bring your infrastructure back into the expected state, thus fixing configuration drift.

## Fix using Terraform Refresh
- To refresh the state of your infrastructure without making any changes, you can use the terraform apply command with the -refresh-only and -auto-approve flags:

```sh
terraform apply -refresh-only -auto-approve
```
This command will update Terraform's state with the latest information from your cloud provider without applying any changes.

## Terraform Modules

### Terraform Module Structure
It's recommended to place modules in a `modules` directory when locally developing modules, but it can be named whatever you feel like. Groovy. 

### Passing Input Variables
We can pass input variables to our module. The module has to declare these terraform variables in its own variables.tf

```terraform
module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name}
```

### Modules Sources
[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)
Using the source we can import the module from various places, such as locally, from Github, or the Terraform Registry.

```terraform
module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"}
```