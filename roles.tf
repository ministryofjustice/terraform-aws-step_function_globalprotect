# Get caller identity for account ID
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "sfn_execution_role" {
  name = "${var.name}-sfn-execution-role"
  path = "/"
  tags = var.tags

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "states.amazonaws.com"
          ]
        },
        "Action" : [
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "sfn_execution_policy" {
  name = "${var.name}-lambda-execution-policy-autoscaling"
  role = aws_iam_role.sfn_execution_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "*"
            ]
        }]
}
EOF
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.name}-lambda-execution-role"
  path = "/"
  tags = var.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "${var.name}-lambda-execution-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "route53:*"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "InvokeLambda",
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction",
          "lambda:ListLayerVersions",
          "lambda:ListLayers",
          "lambda:DeleteFunction",
          "lambda:CreateFunction"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Action": [
          "ec2:*"
        ],
        "Resource": [
          "*"
        ],
        "Effect": "Allow",
        "Sid": "EC2FullAccess"
      },
      {
        "Sid": "StateMachineActions",
        "Effect": "Allow",
        "Action": [
          "states:ListExecutions",
          "states:StartExecution"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "DynamoDbActions",
        "Effect": "Allow",
        "Action": [
          "dynamodb:CreateTable",
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
          "dynamodb:ListTables",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:TagResource",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateTable"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "Logs",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:PutMetricFilter"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutDestination",
          "logs:PutDestinationPolicy",
          "logs:PutLogEvents",
          "logs:PutMetricFilter"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "cloudwatch:*"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:AssociateRouteTable",
          "ec2:AttachInternetGateway",
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:CreateTags",
          "ec2:CreateRoute",
          "ec2:CreateVpcEndpoint",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteRouteTable",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteTags",
          "ec2:DeleteVpcEndpoints",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeVpcEndpointServices",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkInterfaceAttribute",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DetachInternetGateway",
          "ec2:DetachNetworkInterface",
          "ec2:DetachVolume",
          "ec2:DisassociateAddress",
          "ec2:DisassociateRouteTable",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifySubnetAttribute",
          "ec2:MonitorInstances",
          "ec2:RebootInstances",
          "ec2:ReleaseAddress",
          "ec2:ReportInstanceStatus",
          "ec2:TerminateInstances",
          "ec2:DescribeIdFormat"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssm:DescribeParameters"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/autoscaling*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:CompleteLifecycleAction"
        ],
        "Resource": [
          "arn:aws:autoscaling:${var.region}:${data.aws_caller_identity.current.account_id}:autoScalingGroup*"
        ]
      }
    ]
}
EOF
}
