resource "aws_ecr_repository" "ecr_repository" {
  for_each = toset(var.ecr_repo_names)

  name                 = each.value
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
