resource "aws_api_gateway_rest_api" "rest_api" {
  name        = module.label_api.id
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Resources

resource "aws_api_gateway_resource" "authors" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "authors"
}

resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "courses"
}

resource "aws_api_gateway_resource" "courses_id" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

# Stage

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
}

resource "aws_api_gateway_request_validator" "this" {
  name                  = "validate_request_body"
  rest_api_id           = aws_api_gateway_rest_api.rest_api.id
  validate_request_body = true
}

# Get All Authors

resource "aws_api_gateway_method" "get_all_authors" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_all_authors_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_all_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_get_all_authors_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "get_all_authors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = aws_api_gateway_method_response.get_all_authors_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "get_all_authors_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.get_all_authors.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Get All Courses

resource "aws_api_gateway_method" "get_all_courses" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  authorization = "NONE"
  http_method   = "GET"
}

resource "aws_api_gateway_integration" "get_all_courses_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_all_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_get_all_courses_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "get_all_courses_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = aws_api_gateway_method_response.get_all_courses_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "get_all_courses_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.get_all_courses.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method" "courses_option" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "courses_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_integration_response" "courses_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_option.http_method
  status_code = aws_api_gateway_method_response.courses_option_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "courses_option_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.courses_option.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Get Course by ID

resource "aws_api_gateway_method" "get_course_id" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  authorization = "NONE"
  http_method   = "GET"
}

resource "aws_api_gateway_integration" "get_course_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.get_course_id.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_get_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = <<EOF
    {
       "id": "$input.params('id')"
    }
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "get_course_id_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.get_course_id.http_method
  status_code = aws_api_gateway_method_response.get_course_id_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "get_course_id_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.get_course_id.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


# Save Course

resource "aws_api_gateway_method" "save_course" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses.id
  authorization = "NONE"
  http_method   = "POST"
}

resource "aws_api_gateway_integration" "save_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.save_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_save_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "save_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.save_course.http_method
  status_code = aws_api_gateway_method_response.save_course_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "save_course_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.save_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_model" "course_post_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = replace("${module.label_api.id}-PostCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "title": {"type": "string"},
    "authorId": {"type": "string"},
	 "length": {"type": "string"},
    "category": {"type": "string"},
	 "watchHref": {"type": "string"}
  },
  "required": ["title", "authorId", "length", "category"]
}
EOF
}

# Update Course

resource "aws_api_gateway_method" "update_course" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  authorization = "NONE"
  http_method   = "PUT"
}

resource "aws_api_gateway_integration" "update_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.update_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_update_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = <<EOF
    {
       "id": "$input.params('id')",
       "title": "$input.path('$.title')",
       "authorId": "$input.path('$.authorId')",
		 "length": "$input.path('$.length')",
       "category": "$input.path('$.category')",
		 "watchHref": "$input.path('$.watchHref')"
    }
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "update_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.update_course.http_method
  status_code = aws_api_gateway_method_response.update_course_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'PUT,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "update_course_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.update_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_model" "course_put_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = replace("${module.label_api.id}-PutCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "title": {"type": "string"},
    "authorId": {"type": "string"},
	 "length": {"type": "string"},
    "category": {"type": "string"},
	 "watchHref": {"type": "string"}
  },
  "required": ["id", "title", "authorId"]
}
EOF
}

resource "aws_api_gateway_method" "update_course_id_option" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "update_course_id_integration_option" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.update_course_id_option.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_integration_response" "update_course_id_integration_response_option" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.update_course_id_option.http_method
  status_code = aws_api_gateway_method_response.update_course_id_option_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "update_course_id_option_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.update_course_id_option.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Delete Course

resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  authorization = "NONE"
  http_method   = "DELETE"
}

resource "aws_api_gateway_integration" "delete_course_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_delete_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = <<EOF
    {
       "id": "$input.params('id')"
    }
EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "delete_course_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "delete_course_response_200" {
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.delete_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_model" "course_delete_model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = replace("${module.label_api.id}-DeleteCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "id": {"type": "string"}
  },
  "required": ["id"]
}
EOF
}

# Cors

module "cors_authors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.rest_api.id
  api_resource_id = aws_api_gateway_resource.authors.id
}

# module "cors_courses" {
#   source  = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"

#   api_id          = aws_api_gateway_rest_api.this.id
#   api_resource_id = aws_api_gateway_resource.courses.id
# }

# module "cors_courses_id" {
#   source  = "squidfunk/api-gateway-enable-cors/aws"
#   version = "0.3.3"

#   api_id          = aws_api_gateway_rest_api.this.id
#   api_resource_id = aws_api_gateway_resource.courses_id.id
# }
