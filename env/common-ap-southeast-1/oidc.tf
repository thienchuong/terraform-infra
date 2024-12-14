module "github-oidc" {
  source               = "terraform-module/github-oidc-provider/aws"
  version              = "~> 2.2.1"
  role_name            = "github-oidc-role"
  create_oidc_provider = false
  create_oidc_role     = true

  repositories              = ["thienchuong/backend", "thienchuong/frontend"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"]
  tags = {
    Terraform = "true"
  }
}
