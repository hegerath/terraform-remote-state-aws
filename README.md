# terraform-remote-state-aws

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

This project involves the creation of key AWS resources using Terraform. The aim is to establish a central repository for managing the state of application AWS resources and facilitating resource locking for collaborative editing. The variable PROJECT_ENV can be employed to distinguish between different stages (DEV, TEST, PROD). These resources are intended to be created only once within the account.

## Initialize Terraform

Create environment vars

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
```

The access key can be generated in the IAM console in the security information tab.   
More Information on [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

```bash
#cd into project dir (in which main.cf is located)  
terraform init
```

## Create AWS resources

Verify connection and creation of AWS resources

```bash
terraform plan
```

The AWS region could be specified with "aws_region=\<REGION>". Default is "eu-central-1"

```bash
terraform plan -var="AWS_REGION=<region>"
```

The Environment (DEV, TEST, PROD) can be specified with "PROJECT_ENV=\<environment>". Default is "DEV"

```bash
terraform plan -var="PROJECT_ENV=<environment>" 
```

If terraform plan is successfull, you can apply the changes

```bash
terraform apply
```

## Links

[Getting started Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code?utm_medium=WEB_IO&in=terraform%2Faws-get-started&utm_offer=ARTICLE_PAGE&utm_source=WEBSITE&utm_content=DOCS)  
[Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)  
