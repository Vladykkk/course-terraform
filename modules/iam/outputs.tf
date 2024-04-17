output "role_get_all_authors_arn" {
  value = aws_iam_role.get_all_authors.arn
}

output "role_get_all_courses_arn" {
  value = aws_iam_role.get_all_courses.arn
}

output "role_get_course_arn" {
  value = aws_iam_role.get_course.arn
}

output "role_save_course_arn" {
  value = aws_iam_role.save_course.arn
}

output "role_update_course_arn" {
  value = aws_iam_role.update_course.arn
}

output "role_delete_course_arn" {
  value = aws_iam_role.delete_course.arn
}
