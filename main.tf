variable "name" {
  description = "name to prepend to lambda functions and state machine"
  type        = string
}

variable "lambda_execution_role" {
  description = "IAM role attached to the Lambda Function"
  type        = string
}

variable "sfn_execution_role" {
  description = "IAM role attached to the state machine"
  type        = string
}

variable "region" {
  description = "lambda region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "cidr of the VPC"
  type        = string
}

variable "lambda_subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function"
  type        = list(string)
}

variable "ssm_key_panorama_api_key" {
  description = "SSM key name of the panorama api key"
  type        = string
}

variable "gp_client_ip_pool_db_name" {
  description = "name of the dynamo DB which stores GP tunnel client IP pool info"
  type        = string
}

variable "runtime" {
  description = "The identifier of the function's runtime"
  default     = "python3.6"
}

variable "development" {
  description = "Creates zip archives to make developer's life easier"
  type        = bool
  default     = false
}

variable "layer_function_dir" {
  description = "Local dir name of the lambda layer function"
  type        = string
  default     = "lambda_layer_function"
}

variable "layer_function_build_dir" {
  description = "layer function zip directory"
  type        = string
  default     = "package"
}

variable "lambda_function_dir" {
  description = "Local dir name of the lambda functions"
  type        = string
}

variable "lamda_function_src_dir" {
  description = "lambda function source directory"
  type        = string
  default     = "src"
}

variable "lamda_function_build_dir" {
  description = "lambda function source directory"
  type        = string
  default     = "package"
}

variable "public_ipv4_pool" {
  type    = string
  default = "amazon"
}

resource "aws_lambda_layer_version" "as_layer" {
  filename    = "${path.root}/${var.layer_function_dir}/${var.layer_function_build_dir}/layer.zip"
  layer_name  = "${var.name}-as-layer"
  description = "Auto scale lambda layer"

  source_code_hash    = filebase64sha256("${path.root}/${var.layer_function_dir}/${var.layer_function_build_dir}/layer.zip")
  compatible_runtimes = ["python3.6", "python3.7"]
}

# Generate zip files for lambda functions if development variable is true
data "archive_file" "stepfunction" {
  for_each = var.development == true ? toset([for file in fileset("${path.root}/${var.lambda_function_dir}/src", "*.py") : trimsuffix(file, ".py")]) : toset([])

  type        = "zip"
  source_file = "${path.root}/${var.lambda_function_dir}/src/${each.key}.py"
  output_path = "${path.root}/${var.lambda_function_dir}/package/${each.key}.zip"

}

# Create step function s3 bucket
resource "aws_s3_bucket" "stepfunction" {
  bucket_prefix = "${lower(var.name)}-stepfunction"
  acl           = "private"
}

# Upload step function zip to an s3 bucket
resource "aws_s3_bucket_object" "this" {
  for_each = local.lambda_functions
  bucket   = aws_s3_bucket.stepfunction.id
  key      = "${each.key}.zip"
  source   = "${path.root}/${var.lambda_function_dir}/package/${each.key}.zip"
  etag     = filemd5("${path.root}/${var.lambda_function_dir}/package/${each.key}.zip")

  depends_on = [data.archive_file.stepfunction]
}

resource "aws_lambda_function" "this" {
  for_each      = local.lambda_functions
  function_name = "${var.name}-${each.key}"
  s3_bucket     = aws_s3_bucket.stepfunction.id
  s3_key        = aws_s3_bucket_object.this[each.key].id
  handler       = each.value.handler
  role          = var.lambda_execution_role
  timeout       = each.value.timeout
  runtime       = lookup(each.value, "runtime", var.runtime)
  layers        = [aws_lambda_layer_version.as_layer.arn]

  environment {
    variables = lookup(each.value, "environment_variables", null)
  }

  dynamic "vpc_config" {
    for_each = lookup(each.value, "vpc_config", null) != null ? [each.value.vpc_config] : []

    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  source_code_hash = filebase64sha256("${path.root}/${var.lambda_function_dir}/package/${each.key}.zip")
}

locals {
  lambda_functions = {
    setup_firewall = {
      handler = "setup_firewall.lambda_handler"
      timeout = 600
      environment_variables = {
        Region                    = var.region
        gp_client_ip_pool_db_name = var.gp_client_ip_pool_db_name
        ssm_key_panorama_api_key  = var.ssm_key_panorama_api_key
      }
      vpc_config = {
        subnet_ids         = var.lambda_subnet_ids
        security_group_ids = var.security_group_ids
      }
    }
  }
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "${var.name}-AutoscaleStateMachine"
  role_arn = var.sfn_execution_role

  definition = <<EOF
{
  "Comment": "GlobalProtect State function",
  "StartAt": "SetupFirewall",
  "States": {
    "SetupFirewall": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.this["setup_firewall"].arn}",
      "End": true
    }
  }
}
EOF

  depends_on = [aws_lambda_function.this]
}
