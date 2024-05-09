output "cloudwatch_log_group_get_all_authors_arn" {
  value = aws_cloudwatch_log_group.get_all_authors.arn
}

output "cloudwatch_log_group_get_all_courses_arn" {
  value = aws_cloudwatch_log_group.get_all_courses.arn
}

output "cloudwatch_log_group_get_course_arn" {
  value = aws_cloudwatch_log_group.get_course.arn
}

output "cloudwatch_log_group_save_course_arn" {
  value = aws_cloudwatch_log_group.save_course.arn
}

output "cloudwatch_log_group_update_course_arn" {
  value = aws_cloudwatch_log_group.update_course.arn
}

output "cloudwatch_log_group_delete_course_arn" {
  value = aws_cloudwatch_log_group.delete_course.arn
}
