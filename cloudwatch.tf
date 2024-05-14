module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarms-by-multiple-dimensions"
  version = "5.3.1"

  alarm_name          = module.label.id
  alarm_description   = "Errors in ${module.lambdas.lambda_get_all_authors_lambda_function_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"
  treat_missing_data  = "ignore"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  statistic   = "Sum"

  dimensions = {
    "get-all-authors" = {
      FunctionName = "${module.lambdas.lambda_get_all_authors_lambda_function_name}"
    },
    "get-all-courses" = {
      FunctionName = "${module.lambdas.lambda_get_all_courses_lambda_function_name}"
    },
    "get-course" = {
      FunctionName = "${module.lambdas.lambda_get_course_lambda_function_name}"
    },
    "save-course" = {
      FunctionName = "${module.lambdas.lambda_save_course_lambda_function_name}"
    },
    "update-course" = {
      FunctionName = "${module.lambdas.lambda_update_course_lambda_function_name}"
    },
    "delete-course" = {
      FunctionName = "${module.lambdas.lambda_delete_course_lambda_function_name}"
    }
  }

  alarm_actions = [module.notify_slack.slack_topic_arn]
}
