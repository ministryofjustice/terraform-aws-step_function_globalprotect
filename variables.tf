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

variable "vmseries_api_key" {
  description = "VM-series bootstrap admin user's api key"
  type        = string
}

variable "panorama_api_key" {
  description = "Panorama aws_lambda user's api key"
  type        = string
}

variable "panorama_ip_1" {
  description = "Panorama IP 1"
  type        = string
}

variable "panorama_ip_2" {
  description = "Panorama IP 2"
  type        = string
}

variable "host_zone_id" {
  description = "DNS host zone ID"
  type        = string
}

variable "aws_route53_zone" {
  description = "DNS host zone"
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
