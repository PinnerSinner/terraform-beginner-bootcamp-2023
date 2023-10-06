# Terraform Bootcamp - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform


### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a variable.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)


## Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)


## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

https://developer.hashicorp.com/terraform/language/resources/terraform-data

## Provisioners

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)