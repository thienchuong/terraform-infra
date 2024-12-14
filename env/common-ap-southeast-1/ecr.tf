locals {
  repositories = [
    "backend",
    "frontend",
  ]
}
module "ecr" {
  source                          = "terraform-aws-modules/ecr/aws"
  version                         = "2.3.0"
  for_each                        = toset(local.repositories)
  repository_name                 = each.key
  repository_image_tag_mutability = "MUTABLE"
  repository_image_scan_on_push   = false
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "keep last 50 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 50
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform = "true"
    Team      = "DevOps"
  }
}
