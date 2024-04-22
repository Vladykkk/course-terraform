resource "aws_api_gateway_rest_api" "this" {
  name        = module.label_api.id
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}

resource "aws_api_gateway_request_validator" "this" {
  name                  = "validate_request_body"
  rest_api_id           = aws_api_gateway_rest_api.this.id
  validate_request_body = true
}




# #####################


resource "aws_api_gateway_resource" "authors" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_resource" "courses" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_resource" "course" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "course"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_authors" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.authors.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_all_courses" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.courses.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_course" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "save_course" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "update_course" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "delete_course" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_authors" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_authors_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "get_all_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_all_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_courses_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_get_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = jsonencode({
      "id" : "$input.params('id')"
    })
  }

  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "save_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.save_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_save_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = jsonencode({
      id       = "web-fundamentals",
      title    = "Web Component Fundamentals",
      authorId = "cory-house",
      length   = "8:10",
      category = "JS(es6)"
    })
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "update_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.update_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_update_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = jsonencode({
      id        = "backend-fundamentals",
      title     = "Updated Web Component Fundamentals",
      authorId  = "cory-house",
      length    = "6:30",
      category  = "HTML5"
      watchHref = "http://www.pluralsight.com/courses/backend-fundamentals"
    })
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration" "delete_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambdas.lambda_delete_course_invoke_arn
  request_parameters      = { "integration.request.header.X-Authorization" = "'static'" }
  request_templates = {
    "application/json" = jsonencode({
      "id" : "$input.params('id')"
    })
  }

  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_authors" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.get_authors.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_method_response" "get_all_courses" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.get_all_courses.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_method_response" "get_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.get_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_method_response" "save_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.save_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_method_response" "update_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.update_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_method_response" "delete_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.delete_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = false
  }
}

resource "aws_api_gateway_integration_response" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = aws_api_gateway_method_response.get_authors.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "get_all_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = aws_api_gateway_method_response.get_all_courses.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "save_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.save_course.http_method
  status_code = aws_api_gateway_method_response.save_course.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "update_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.update_course.http_method
  status_code = aws_api_gateway_method_response.update_course.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'PUT,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "delete_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

module "cors_authors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.authors.id
}

module "cors_courses" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.courses.id
}

module "cors_course" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.course.id
}
