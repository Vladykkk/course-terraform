module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  label_order = var.label_order
  delimiter   = "-"
}

module "label_api" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context

  name = "api"

  tags = {
    Name = local.tag_name
  }
}

module "label_s3" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context

  name = "s3"

  tags = {
    Name = local.tag_name
  }
}

module "label_front_app" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context

  name = "front-app"

  tags = {
    Name = local.tag_name
  }
}
