# Create an IAM policy for Lambda function creation
resource "aws_iam_policy" "lambda_create_policy" {
  name        = "LambdaCreatePolicy"
  description = "Policy for Lambda function creation"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "lambda:CreateFunction",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

# Attach the Lambda create policy to the IAM user
resource "aws_iam_user_policy_attachment" "lambda_create_attach" {
  user       = "cesar"  # Update with the actual username
  policy_arn = aws_iam_policy.lambda_create_policy.arn
}
