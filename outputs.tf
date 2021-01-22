output "lambda_scale_sfn_init_arn" {
  value = aws_lambda_function.sfn_init["start_sfn"].arn
}

output "lambda_scale_sfn_init_name" {
  # Get lambda function name by splitting arn ":"
  value = element(split(":", aws_lambda_function.sfn_init["start_sfn"].arn), length(split(":", aws_lambda_function.sfn_init["start_sfn"].arn)) - 1)
}
