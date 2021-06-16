variable "name" {
  description = "name to prepend to lambda functions and state machine"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  description = "lambda region"
  type        = string
  default     = "eu-west-2"
}

variable "lambda_subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function"
  type        = list(string)
}

variable "vmseries_api_key_ssm_key" {
  description = "VM-series bootstrap admin user's api key is stored under this parameter name in SSM"
  type        = string
}

variable "panorama_api_key_ssm_key" {
  description = "Panorama aws_lambda user's api key is stored under this parameter name in SSM"
  type        = string
}

variable "userid_collector_name_ssm_key" {
  description = "User-ID collector name is stored under this parameter name in SSM"
  type        = string
}

variable "userid_agent_secret_ssm_key" {
  description = "User-ID collector pre-shared key is stored under this parameter name in SSM"
  type        = string
}

variable "log-collector-group_ssm_key" {
  description = "Log collector group name is stored under this parameter name in SSM"
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

variable "gp_client_ip_pools" {
  type    = list(any)
  default = []
}

variable "availability_zones" {
  type        = list(string)
  description = "(optional) availability zones in the region"
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "suffix_map" {
  type    = list(string)
  default = ["A", "B", "C", "D"]
}

variable "gp_gateway_hostname_template" {
  type    = string
  default = "MOJ-AW2-FW%02d%s"
}

variable "tgw_rtb_id" {
  description = "ID of the transit gateway route table"
  type        = string
}

variable "cloudwatch_alarm_switch_cron" {
  description = "Cron schedule to run CloudWatch Event rule which inturn will trigger a lambda function to enable/disable GP scale in event"
  type        = string
  default     = "0 2,58 7,20 ? * MON,TUE,WED,THU,FRI *"
}

# DO NOT MODIFY THIS VARIABLE IF YOU DO NOT FULLY UNDERSTAND THE CHANGE
variable "reset_db_input" {
  description = "Flag to reset GlobalProtect GP Dynamo DB"
  type        = map(string)
  default     = {}
  # default = {
  #   reset_db = True
  # }
}
