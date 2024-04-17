module "iam_policy_authors" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_get_all_authors.id
  path        = "/"
  description = "Authors policy"

  policy = data.aws_iam_policy_document.get_all_authors.json
}

module "iam_policy_courses" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "v5.37.2"
  name        = module.label_get_all_courses.id
  path        = "/"
  description = "Courses policy"

  policy = data.aws_iam_policy_document.get_all_courses.json
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
