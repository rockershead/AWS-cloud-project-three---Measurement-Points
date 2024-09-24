# Create the REST API
resource "aws_api_gateway_rest_api" "mpt_api" {
  name        = "MPT API"
  description = "API for querying measurement points"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
}


resource "aws_api_gateway_resource" "mpt" {
  rest_api_id = aws_api_gateway_rest_api.mpt_api.id
  parent_id   = aws_api_gateway_rest_api.mpt_api.root_resource_id
  path_part   = "mpt"
}

resource "aws_api_gateway_resource" "mpt_by_id" {
  rest_api_id = aws_api_gateway_rest_api.mpt_api.id
  parent_id   = aws_api_gateway_resource.mpt.id
  path_part   = "{device_id}"
}


resource "aws_api_gateway_method" "get_mpt" {
  rest_api_id   = aws_api_gateway_rest_api.mpt_api.id
  resource_id   = aws_api_gateway_resource.mpt_by_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the GET method with the Lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.mpt_api.id
  resource_id             = aws_api_gateway_resource.mpt_by_id.id
  http_method             = aws_api_gateway_method.get_mpt.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_mpt_lambda.invoke_arn
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_mpt_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_mpt_lambda.account_id}:${aws_api_gateway_rest_api.mpt_api.id}/*/GET/mpt/*"
}

# Deploy the API
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.mpt_api.id
  stage_name  = "prod"

  depends_on = [aws_api_gateway_integration.lambda_integration]
}


# VPC Endpoint for API Gateway
resource "aws_vpc_endpoint" "api_gateway_endpoint" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.ap-southeast-1.execute-api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [for subnet in aws_subnet.private_subnets : subnet.id]
  security_group_ids = [aws_security_group.security_group.id]
  tags = {
    Name = "${var.vpc_name}_api_gateway_endpoint"
  }
}

# Resource Policy to restrict access to the VPC Endpoint
data "aws_iam_policy_document" "mpt_policy_document" {

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["arn:aws:execute-api:ap-southeast-1:${data.aws_caller_identity.current_caller_for_get_mpt_lambda.account_id}:${aws_api_gateway_rest_api.mpt_api.id}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = [aws_vpc_endpoint.api_gateway_endpoint.id]
    }
  }

}

resource "aws_api_gateway_rest_api_policy" "mpt_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.mpt_api.id
  policy      = data.aws_iam_policy_document.mpt_policy_document.json
}


