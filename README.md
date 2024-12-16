# Terraform-infra

## Terraform module structure
```
├── env
│   ├── common-ap-southeast-1  <- for deploying common aws services in region ap-southeast-1
│   │   ├── ecr.tf
│   │   ├── oidc.tf
│   │   └── provider.tf
│   └── dev-ap-southeast-1     <- for deploying dev environment in region ap-southeast-1
│       ├── acm.tf
│       ├── data.tf
│       ├── eks.tf
│       ├── irsa.tf
│       ├── network.tf
│       ├── output.tf
│       ├── provider.tf
│       ├── route53.tf
│       └── s3.tf
└── modules                     <- Terraform modules for reusable for all environment
    ├── eks
    │   ├── eks.tf
    │   ├── output.tf
    │   └── variable.tf
    ├── network
    │   ├── output.tf
    │   ├── variable.tf
    │   └── vpc.tf
    └── s3
        ├── output.tf
        ├── s3.tf
        └── variable.tf
```
## Terraform plan
- Creating pull request will trigger github action for run the plan

## Terraform apply

- After reviewed the plan, get approved and merged to main branch, github action for plan and apply the terraform codes. The terraform state is storing on Terraform Cloud

## Authentication and authorization

- We use aws iam role to assume role to get temp credentials for deploying resources on aws. By this approach we no longer need to create and store aws keys

## What we deployed in this repo:
- vpc
- natgw
- private subnet
- public subnet
- db subnet
- s3
- eks
- irsa
- acm
- route53
