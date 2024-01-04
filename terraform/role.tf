resource "aws_iam_role" "my_role" {
  name = "MyGoApplication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${module.eks.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:${local.app_namespace}:${local.app_service_account}",
            "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  inline_policy {
    name = "my_inline_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject"
          ]
          Resource = ["arn:aws:s3:::my-web-assets/*"]
        },
        {
          Effect = "Allow"
          Action = [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage"
          ]
          Resource = ["arn:aws:sqs:ap-southeast-1:123456789123:lms-import-data"]
        },
      ]
    })
  }
}
