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

module "label_save_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "save-course"
}

module "label_update_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "update-course"
}

module "label_get_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "get-course"
}

module "label_delete_course" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "delete-course"
}

module "lambda_function_authors" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_get_all_authors.id
  description   = "Get all authors"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  create_role   = false

  lambda_role = var.role_get_all_authors_arn

  source_path = "${path.module}/src/get_all_authors"

  environment_variables = {
    TABLE_NAME = var.table_authors_name
  }

  tags = module.label_get_all_authors.tags
}

module "lambda_function_courses" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_get_all_courses.id
  description   = "Get all courses"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  create_role   = false

  lambda_role = var.role_get_all_courses_arn

  source_path = "${path.module}/src/get_all_courses"

  environment_variables = {
    TABLE_NAME = var.table_courses_name
  }

  tags = module.label_get_all_courses.tags
}

module "lambda_save_course" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_save_course.id
  description   = "Save course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/save_course"

  environment_variables = {
    TABLE_NAME = var.table_courses_name
  }

  tags = module.label_get_all_courses.tags
}

module "lambda_update_course" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_update_course.id
  description   = "Update course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/update_course"

  environment_variables = {
    TABLE_NAME = var.table_courses_name
  }

  tags = module.label_get_all_courses.tags
}

module "lambda_get_course" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_get_course.id
  description   = "Get course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/get_course"

  environment_variables = {
    TABLE_NAME = var.table_courses_name
  }

  tags = module.label_get_all_courses.tags
}

module "lambda_delete_course" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.3"

  function_name = module.label_delete_course.id
  description   = "Delete course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  source_path = "${path.module}/src/delete_course"

  environment_variables = {
    TABLE_NAME = var.table_courses_name
  }

  tags = module.label_get_all_courses.tags
}
