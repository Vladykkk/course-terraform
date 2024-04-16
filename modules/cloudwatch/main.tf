module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = var.context
}

module "label_get_all_authors" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "get-all-authors"
}

module "label_get_all_courses" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "get-all-courses"
}

resource "aws_cloudwatch_log_group" "get_all_authors" {
  name              = module.label_get_all_authors.id
  tags              = module.label_get_all_authors.tags
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "get_all_courses" {
  name              = module.label_get_all_courses.id
  tags              = module.label_get_all_courses.tags
  retention_in_days = 90
}
