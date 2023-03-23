A terraform module for deploying lambda functions, state functions, required roles, and Dynamo DB for gateway tracking.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_dynamodb_table.gp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sfn_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sfn_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.sfn_init](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.as_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.stepfunction](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.sfn_init_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_sfn_state_machine.sfn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [archive_file.nodejslambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.stepfunction](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_lambda_invocation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_invocation) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | (optional) availability zones in the region | `list(string)` | <pre>[<br>  "eu-west-2a",<br>  "eu-west-2b",<br>  "eu-west-2c"<br>]</pre> | no |
| <a name="input_aws_route53_zone"></a> [aws\_route53\_zone](#input\_aws\_route53\_zone) | DNS host zone | `string` | n/a | yes |
| <a name="input_cloudwatch_alarm_switch_cron"></a> [cloudwatch\_alarm\_switch\_cron](#input\_cloudwatch\_alarm\_switch\_cron) | Cron schedule to run CloudWatch Event rule which inturn will trigger a lambda function to enable/disable GP scale in event | `string` | `"0 2,58 7,20 ? * MON,TUE,WED,THU,FRI *"` | no |
| <a name="input_development"></a> [development](#input\_development) | Creates zip archives to make developer's life easier | `bool` | `false` | no |
| <a name="input_gp_client_ip_pools"></a> [gp\_client\_ip\_pools](#input\_gp\_client\_ip\_pools) | n/a | `list(any)` | `[]` | no |
| <a name="input_gp_gateway_hostname_template"></a> [gp\_gateway\_hostname\_template](#input\_gp\_gateway\_hostname\_template) | n/a | `string` | `"MOJ-AW2-FW%02d%s"` | no |
| <a name="input_host_zone_id"></a> [host\_zone\_id](#input\_host\_zone\_id) | DNS host zone ID | `string` | n/a | yes |
| <a name="input_lambda_function_dir"></a> [lambda\_function\_dir](#input\_lambda\_function\_dir) | Local dir name of the lambda functions | `string` | n/a | yes |
| <a name="input_lambda_subnet_ids"></a> [lambda\_subnet\_ids](#input\_lambda\_subnet\_ids) | A list of subnet IDs associated with the Lambda function | `list(string)` | n/a | yes |
| <a name="input_lamda_function_build_dir"></a> [lamda\_function\_build\_dir](#input\_lamda\_function\_build\_dir) | lambda function source directory | `string` | `"package"` | no |
| <a name="input_lamda_function_src_dir"></a> [lamda\_function\_src\_dir](#input\_lamda\_function\_src\_dir) | lambda function source directory | `string` | `"src"` | no |
| <a name="input_layer_function_build_dir"></a> [layer\_function\_build\_dir](#input\_layer\_function\_build\_dir) | layer function zip directory | `string` | `"package"` | no |
| <a name="input_layer_function_dir"></a> [layer\_function\_dir](#input\_layer\_function\_dir) | Local dir name of the lambda layer function | `string` | `"lambda_layer_function"` | no |
| <a name="input_log_collector_group_ssm_key"></a> [log\_collector\_group\_ssm\_key](#input\_log\_collector\_group\_ssm\_key) | Log collector group name is stored under this parameter name in SSM | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | name to prepend to lambda functions and state machine | `string` | n/a | yes |
| <a name="input_panorama_api_key_ssm_key"></a> [panorama\_api\_key\_ssm\_key](#input\_panorama\_api\_key\_ssm\_key) | Panorama aws\_lambda user's api key is stored under this parameter name in SSM | `string` | n/a | yes |
| <a name="input_panorama_ip_1"></a> [panorama\_ip\_1](#input\_panorama\_ip\_1) | Panorama IP 1 | `string` | n/a | yes |
| <a name="input_panorama_ip_2"></a> [panorama\_ip\_2](#input\_panorama\_ip\_2) | Panorama IP 2 | `string` | n/a | yes |
| <a name="input_public_ipv4_pool"></a> [public\_ipv4\_pool](#input\_public\_ipv4\_pool) | n/a | `string` | `"amazon"` | no |
| <a name="input_region"></a> [region](#input\_region) | lambda region | `string` | `"eu-west-2"` | no |
| <a name="input_reset_db_input"></a> [reset\_db\_input](#input\_reset\_db\_input) | Flag to reset GlobalProtect GP Dynamo DB | `map(string)` | `{}` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The identifier of the function's runtime | `string` | `"python3.6"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs associated with the Lambda function | `list(string)` | n/a | yes |
| <a name="input_suffix_map"></a> [suffix\_map](#input\_suffix\_map) | n/a | `list(string)` | <pre>[<br>  "A",<br>  "B",<br>  "C",<br>  "D"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_tgw_rtb_id"></a> [tgw\_rtb\_id](#input\_tgw\_rtb\_id) | ID of the transit gateway route table | `string` | n/a | yes |
| <a name="input_userid_agent_secret_ssm_key"></a> [userid\_agent\_secret\_ssm\_key](#input\_userid\_agent\_secret\_ssm\_key) | User-ID collector pre-shared key is stored under this parameter name in SSM | `string` | n/a | yes |
| <a name="input_userid_collector_name_ssm_key"></a> [userid\_collector\_name\_ssm\_key](#input\_userid\_collector\_name\_ssm\_key) | User-ID collector name is stored under this parameter name in SSM | `string` | n/a | yes |
| <a name="input_vmseries_api_key_ssm_key"></a> [vmseries\_api\_key\_ssm\_key](#input\_vmseries\_api\_key\_ssm\_key) | VM-series bootstrap admin user's api key is stored under this parameter name in SSM | `string` | n/a | yes |
| <a name="input_panorama_auth_key_ssm_key"></a> [panorama\_auth\_key\_ssm\_key](#input\_panorama\_auth\_key\_ssm\_key) | Panorama Device Auth Key new in PANOS 10.x is stored under this parameter name in SSM | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_scale_sfn_init_arn"></a> [lambda\_scale\_sfn\_init\_arn](#output\_lambda\_scale\_sfn\_init\_arn) | n/a |
| <a name="output_lambda_scale_sfn_init_name"></a> [lambda\_scale\_sfn\_init\_name](#output\_lambda\_scale\_sfn\_init\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
