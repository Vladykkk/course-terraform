module "iam_policy_get_all_authors" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_get_all_authors.id
  path        = "/"
  description = "Get all authors policy"

  policy = data.aws_iam_policy_document.get_all_authors.json
}

module "iam_policy_get_all_courses" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_get_all_courses.id
  path        = "/"
  description = "Get all courses policy"

  policy = data.aws_iam_policy_document.get_all_courses.json
}

module "iam_policy_get_course" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_get_course.id
  path        = "/"
  description = "Get course policy"

  policy = data.aws_iam_policy_document.get_course.json
}

module "iam_policy_save_course" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_save_course.id
  path        = "/"
  description = "Save course policy"

  policy = data.aws_iam_policy_document.save_course.json
}

module "iam_policy_update_course" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_update_course.id
  path        = "/"
  description = "Update course policy"

  policy = data.aws_iam_policy_document.update_course.json
}

module "iam_policy_delete_course" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_delete_course.id
  path        = "/"
  description = "Delete course policy"

  policy = data.aws_iam_policy_document.delete_course.json
}

data "aws_iam_policy_document" "get_all_authors" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Scan",
    ]

    resources = [var.table_authors_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_get_all_authors_arn}:*:*",
      "${var.cloudwatch_log_group_get_all_authors_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "get_all_courses" {
  statement {
    actions = [
      "dynamodb:Scan",
    ]

    resources = [var.table_courses_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_get_all_courses_arn}:*:*",
      "${var.cloudwatch_log_group_get_all_courses_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "get_course" {
  statement {
    actions = [
      "dynamodb:GetItem",
    ]

    resources = [var.table_courses_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_get_course_arn}:*:*",
      "${var.cloudwatch_log_group_get_course_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "save_course" {
  statement {
    actions = [
      "dynamodb:PutItem",
    ]

    resources = [var.table_courses_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_save_course_arn}:*:*",
      "${var.cloudwatch_log_group_save_course_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "update_course" {
  statement {
    actions = [
      "dynamodb:PutItem",
    ]

    resources = [var.table_courses_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_update_course_arn}:*:*",
      "${var.cloudwatch_log_group_update_course_arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "delete_course" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
    ]

    resources = [var.table_courses_arn]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${var.cloudwatch_log_group_delete_course_arn}:*:*",
      "${var.cloudwatch_log_group_delete_course_arn}:*"
    ]
  }
}
