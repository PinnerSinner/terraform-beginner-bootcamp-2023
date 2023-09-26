# Terraform Beginner Bootcamp 2023 - Week 0 
# Table of Contents 
- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle](#gitpod-lifecycle)
- [Working Env Vars](#working-env-vars)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
    + [Terraform Lock Files](#terraform-lock-files)
    + [Terraform State Files](#terraform-state-files)
    + [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning

This project is going utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distribution

This project is built against Ubunutu.
Please consider checking your Linux Distrubtion and change accordingly to distrubtion needs. This project is built against Ubuntu 22.04.3 LTS . Please consider checking your own Linux Distribution to see if it requires any changes according to your distribution needs.

[How To Check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we notice that bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI. 

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better portablity for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang (prounced Sha-bang) tells the bash script what program that will interpet the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions 
-  will search the user's PATH for the bash executable
For simple script executions. Different scripts may be written in different programming languages, and specifying the correct interpreter ensures that the script is executed with the appropriate language interpreter
For portability. Without a shebang line, you would need to explicitly specify the interpreter each time you run the script, like python3 script.py. With a shebang, you can simply make the script executable (chmod +x script.py) and then run it directly with ./script.py.
For consistency. Shebang lines promote consistency and clarity in script execution. Anyone who looks at the script can quickly see which interpreter it requires without needing to examine the code
https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notiation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml  we need to point the script to a program to interpert it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be exetuable at the user mode.
If we are using a script in .gitpod.yml, we need to point the script to a program to interpret it. Such as source ./bin/install_terraform_cli
Linux Permissions and considerations
Linux chmod permissions control access to files and directories. They are divided into three categories: owner, group, and others. Each category can have read (r), write (w), and execute (x) permissions. 'r' allows reading, 'w' allows writing, and 'x' allows executing files or accessing directories. You can use commands like chmod to change these permissions, ensuring the security and accessibility of your files in Linux.

In order to make our bash scripts executable we need to change the linux permissions for the fix to be executable at the user category.
chmod u+x ./bin/install_terraform_cli
Alternatively,

chmod 744 ./bin/install_terraform_cli
```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.
When using git init in an existing workspace or directory, it initializes a new Git repository if one doesn't already exist. However, if a Git repository has been previously initialized in that directory, running git init again won't re-run the initialization process. Instead, it will have no effect and won't alter the existing repository. So, it's important to be cautious and use git init only when you intend to create a new Git repository or reinitialize a directory.

In the GitHub repository lifecycle, "before" refers to the preparation stage before creating a repository. "Init" involves initializing a new Git repository in a local directory using git init.
Once initialized, you can use various Git commands, such as git add, git commit, and git push, to manage and collaborate on your project, which are essential for version control and collaboration on GitHub. Information on Workspace Lifecycle
https://www.gitpod.io/docs/configure/workspaces/tasks

## Working Env Vars

### env command

We can list out all Enviroment Variables (Env Vars) using the `env` command. Environment variables, or env vars, are a way to configure software and store important information. They're like labels with values, used to customise programs. Env Vars are handy because they allow to change software settings without editing code. They consist of a name and a value, helping programs adapt to different environments.

We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world`

In the terrminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`Setting environment variables at the global scope typically involves defining them in a way that they are accessible to all processes and applications running on a system. It can change based on operating systems, but for Linux/Unix(bash) we can set env vars by adding them to a system-wide configuration file like /etc/environment or by creating custom files in the /etc/profile.d/ directory

When you open up new bash terminals in VSCode it won't be aware of env vars that've been set in another window. Environment variables set in one terminal session are typically not automatically available in other terminal sessions.
To persist environment variables across future Bash terminals in a way that they are available every time you open a new terminal session, you should add them to your Bash profile configuration files

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.

You can also set en vars in the `.gitpod.yml` but this can only contain non-senstive env vars.

## AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)


[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "WOLOLOLOLOLO",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/IntermediateA.I."
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in terraform. Providers are like connectors in Terraform. They help you interact with various cloud or infrastructure services (e.g., AWS, Azure, Google Cloud) or other systems (e.g., databases) to create, update, or manage resources. For example, If you want to create an AWS EC2 instance, you'd use the AWS provider to communicate with AWS services
- **Modules** are a way to make large amount of terraform code modular, portable and sharable. Modules are reusable templates or blueprints for creating sets of related resources. They make it easier to manage and organize your infrastructure code by breaking it into smaller, reusable parts.
You might create a module for a web server that includes an EC2 instance, security group, and load balancer configuration. You can then reuse this module for multiple web servers. It's a way to make large amount of terraform code modular, portable and repeatable. The idea behind Terraform modules is to promote code reusability, maintainability, and modularity in your infrastructure as code (IaC) projects. Modules allow you to encapsulate and package together a set of related Terraform resources, configurations, and logic into a single, reusable component

[Randon Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

In a nutshell, providers connect Terraform to external services, while modules help you structure and reuse your infrastructure code. They're both essential for managing infrastructure as code effectively.

### Terraform Console

We can see a list of all the Terrform commands by simply typing `terraform`


#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.
It's like preparing a toolbox before going ahead to start doing some DIY at home. It's a command to ensure that we have all the right tools (binaries) ready for the job.
In this case "tools" are Terraform providers which are connnectors to various cloud or infrastructure services. Step by step, running terraform init will:
[] Download Providers: Fetching the necessary TF provider binaries for the cloud services or resources to be used in the project. Providers are like translators that help TF talk to specific services like AWS etc.
[] Creates a working directory: It sets up a _".terraform" directory in the project folder to store these downloaded binaries within along with other config files. Inside which will be stored a hash in the lock file ".terraform.lock.hcl" to make sure that once we begin defining infrastructure, Terraform knows how to communicate with services and resources. After having run terraform init

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed. It's to avoid unintended changes or whoopsies when applying configurations. + indicates a resource to be created. ~ indicates a resource to be updated. - indicates a resource to be destroyed.
For example,
+ aws_instance.my_instance
~ aws_security_group.my_security_group
- aws_instance.old_instance
It's there to review the plan before applying changes to infrastructure

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This is the command to make the infrastructure changes come to life. It takes the plan created in terraform plan and carries out the state changes by deploying and managing those resources.
It turns infrastructure code into actual resources, creating servers, networks, databases and buckets. In the terminal, after running terraform apply, it'll ask to confirm changes. yes is to proceed, which can be expedited with . `terraform apply --auto-approve`
Then, it'll CRUD those resources as defined in the configuration, store the state of the infrastructure in a state file (usually named _terraform.tfstate) to keep an eye on current state, and show an example output such as:
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.my_instance will be created
  + resource "aws_instance" "my_instance" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t2.micro"
      # ...
    }

#### Terraform Destroy

`teraform destroy`
It's a command to nuke the infrastructure resources terraform destroy It will display a list of resources that it plans to destroy, to which we can -- auto-approve to expedite.
Terraform will initiate the process to destroy those resources, but use the auto approve flag to skip the approve prompt eg. `terraform apply --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modulues that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

#### Terraform State Files

`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be commited** to your VCS because it contains sensitive data, plus if it's lost or overwritten, we lose knowing the state of our infrastructure.

If you lose this file, you lose knowning the state of your infrastructure. Mercifully, we have terraform.tfstate.backup which is the previous state of the backup, as per the serial

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
``````
To update manually, visit Terraform Cloud > User profile > Generate token. Inside the cli type in:
```
gp env TERRAFORM_CLOUD_TOKEN=""
export TERRAFORM_CLOUD_TOKEN
```
We have automated this workaround with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)
