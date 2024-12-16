# Terraform-infra

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
