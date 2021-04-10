A terraform module for deploying lambda functions, state functions, required roles, and Dynamo DB for gateway tracking.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | (optional) availability zones in the region | `list(string)` | <pre>[<br>  "eu-west-2a",<br>  "eu-west-2b",<br>  "eu-west-2c"<br>]</pre> | no |
| aws\_route53\_zone | DNS host zone | `string` | n/a | yes |
| development | Creates zip archives to make developer's life easier | `bool` | `false` | no |
| gp\_client\_ip\_pools | n/a | `map(string)` | `{}` | no |
| gp\_gateway\_hostname\_template | n/a | `string` | `"MOJ-AW2-FW%02d%s"` | no |
| host\_zone\_id | DNS host zone ID | `string` | n/a | yes |
| lambda\_function\_dir | Local dir name of the lambda functions | `string` | n/a | yes |
| lambda\_subnet\_ids | A list of subnet IDs associated with the Lambda function | `list(string)` | n/a | yes |
| lamda\_function\_build\_dir | lambda function source directory | `string` | `"package"` | no |
| lamda\_function\_src\_dir | lambda function source directory | `string` | `"src"` | no |
| layer\_function\_build\_dir | layer function zip directory | `string` | `"package"` | no |
| layer\_function\_dir | Local dir name of the lambda layer function | `string` | `"lambda_layer_function"` | no |
| name | name to prepend to lambda functions and state machine | `string` | n/a | yes |
| panorama\_api\_key\_ssm\_key | Panorama aws\_lambda user's api key is stored under this parameter name in SSM | `string` | n/a | yes |
| panorama\_ip\_1 | Panorama IP 1 | `string` | n/a | yes |
| panorama\_ip\_2 | Panorama IP 2 | `string` | n/a | yes |
| public\_ipv4\_pool | n/a | `string` | `"amazon"` | no |
| region | lambda region | `string` | `"eu-west-2"` | no |
| runtime | The identifier of the function's runtime | `string` | `"python3.6"` | no |
| security\_group\_ids | A list of security group IDs associated with the Lambda function | `list(string)` | n/a | yes |
| suffix\_map | n/a | `list(string)` | <pre>[<br>  "A",<br>  "B",<br>  "C",<br>  "D"<br>]</pre> | no |
| tags | n/a | `map(string)` | `{}` | no |
| tgw\_rtb\_id | ID of the transit gateway route table | `string` | n/a | yes |
| vmseries\_api\_key\_ssm\_key | VM-series bootstrap admin user's api key is stored under this parameter name in SSM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_scale\_sfn\_init\_arn | n/a |
| lambda\_scale\_sfn\_init\_name | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
