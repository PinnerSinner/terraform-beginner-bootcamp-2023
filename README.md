# Terraform Beginner Bootcamp 2023

##Semantic Versioning :mage:

This project is going to use semantic versioning for its tagging. 
[semver.org](https://semver.org/)

### The general format

- Given a version number MAJOR.MINOR.PATCH, increment the:

- **MAJOR** version when you make incompatible API changes, e.g. `1.0.1`
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
- Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So the original gitpod.yml bash configuration was outdated and would require manual intervention.
- [Install the Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
Referred to the latest Terraform CLI install instructions via Terraform Documentation and change the scripting for install

### Considerations for Linux Distribtion 
- This project is built against Ubuntu 22.04.3 LTS . Please consider checking your own Linux Distribution to see if it requires any changes according to your distribution needs. 
[How to check Linux version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)
[Other article](https://www.tecmint.com/check-linux-os-version/#:~:text=The%20best%20way%20to%20determine,on%20almost%20all%20Linux%20systems.)
- Example of checking OS version:
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

### Refactoring into Bash scripts
While fixing the Terraform CLI gpg depracation issues, I noticed that the installation steps for bash were a considerable amount of more code. So, I decided to create a amended bash script to replace the Terraform CLI. 
This will keep the GitPod Task File ([gitpod.yml)(.gitpod.yml)]) tidy, and an easier time to debug and execute manually Terraform CLI install for better portability across other projects requiring Terraform CLI install. 
Bash script located here: [./bin.install_terraform_cli](./bin/install_terraform_cli)

### Shebang

A ***"shebang"*** (pronounced ___shah bang__) for Ubuntu (and most Unix-like operating systems) goes at the beginning of your script to specify the interpreter that should be used to run the script. e.g., `#!/bin/bash`
- For simple script executions. Different scripts may be written in different programming languages, and specifying the correct interpreter ensures that the script is executed with the appropriate language interpreter
- For portability. Without a shebang line, you would need to explicitly specify the interpreter each time you run the script, like python3 script.py. With a shebang, you can simply make the script executable (chmod +x script.py) and then run it directly with ./script.py.
- For consistency. Shebang lines promote consistency and clarity in script execution. Anyone who looks at the script can quickly see which interpreter it requires without needing to examine the code

## Execution Considerations 

When executing the bash script we can use the `./` shorthand notation to execute the bash script 
[information on "shebang"](https://en.wikipedia.org/wiki/Shebang_(Unix))
- If we are using a script in .gitpod.yml, we need to point the script to a program to interpret it. Such as `source ./bin/install_terraform_cli`

### Linux Permissions and considerations

Linux chmod permissions control access to *files* and *directories*. They are divided into three categories: *owner, group, and others*. Each category can have _read (r), write (w), and execute (x)_ permissions. 'r' allows reading, 'w' allows writing, and 'x' allows executing files or accessing directories. You can use commands like chmod to change these permissions, ensuring the security and accessibility of your files in Linux.

- In order to make our bash scripts executable we need to change the linux permissions for the fix to be executable at the user category. 
```sh
chmod u+x ./bin/install_terraform_cli
```

> Alternatively,
```sh
chmod 744 ./bin/install_terraform_cli
```
[Information found here](https://en.wikipedia.org/wiki/Chmod#:~:text=access%20the%20file.-,Numerical%20permissions,%2C%20setgid%2C%20and%20sticky%20flags.)

### GitHub Lifecycle (Before, Init, Command)

When using git init in an existing workspace or directory, it initializes a new Git repository if one doesn't already exist. However, if a Git repository has been previously initialized in that directory, running git init again *won't re-run the initialization process*. Instead, it will have no effect and won't alter the existing repository. So, it's important to be cautious and use git init only when you intend to create a new Git repository or reinitialize a directory.

- In the GitHub repository lifecycle, "before" refers to the preparation stage before creating a repository. "Init" involves initializing a new Git repository in a local directory using git init. 
- Once initialized, you can use various Git commands, such as git add, git commit, and git push, to manage and collaborate on your project, which are essential for version control and collaboration on GitHub.
[Information on Workspace Lifecycle](https://www.gitpod.io/docs/configure/workspaces/workspace-lifecycle)

### Working with Env Vars

Environment variables, or env vars, are a way to configure software and store important information. They're like labels with values, used to customise programs. Env Vars are handy because they allow to change software settings without editing code. They consist of a name and a value, helping programs adapt to different environments. 
- We can list out all environment variables using the `env` command 
- We can filter specific env vars using grep, eg. `env | grep AWS_`

### Setting and unsetting Env Vars
- In the terminal we can set using `export HELLO=world`
- And do unset, use `unset HELLO`
- Can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writing export e.g.,

```sh
#!/usr/bin/env bash
HELLO='world'
echo $HELLO
```

### Printing Vars
- We can print out an env var using echo e.g. `echo $HELLO`

### Scoping of Env Vars
Setting environment variables at the global scope typically involves defining them in a way that they are accessible to all processes and applications running on a system. It can change based on operating systems, but for Linux/Unix(bash) we can set env vars by adding them to a system-wide configuration file like `/etc/environment` or by creating custom files in the `/etc/profile.d/` directory
- When you open up new bash terminals in VSCode it won't be aware of env vars that've been set in another window. Environment variables set in one terminal session are typically not automatically available in other terminal sessions. 
- To persist environment variables across future Bash terminals in a way that they are available every time you open a new terminal session, you should add them to your Bash profile configuration files

### Persisting env vars in GitPod

We can persist env vars into gitpod by storing them in GitPod parameter store/secrets storage. 
```
gp env HELLO='world'
```
All future workspaces launched will set the env vars for all bash terminals opened in those workspaces. 
- Can also set env vars in the `.gitpod.yml` but this must be only used for non sensitive information for best practices

### AWS CLI Installation 

The AWS CLI is a command-line tool provided by Amazon Web Services (AWS) for interacting with AWS services and resources. It allows you to manage and automate AWS resources and operations directly from your terminal.

- The CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)
[Getting started Installing (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Good habit to check if AWS credentials are configured correctly by running the following CLI command: 
```sh
aws sts get-caller-identity
```
[Setting up AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

- Upon success, should be returned with a JSON payload that looks like this:

```json
AWS_ACCESS_KEY_ID='WOWOWOWOWOWOWOWOWOWO'
AWS_SECRET_ACCESS_KEY='WOLOLOLOLOLOLOLOLOLOLOLOLOLO'
AWS_DEFAULT_REGION='us-west-2'
```

Will need to generate ALI CLI access keys in order to gain admin permissions inhereted from IAM User. 