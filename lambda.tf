# Define the AWS Lambda function for image processing
resource "aws_lambda_function" "image_processing_lambda" {
  filename      = "image_processing_lambda.zip"  # Update with your actual zip file name
  function_name = "image-processing-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "image_processing_lambda.lambda_handler"
  runtime       = "python3.8"
}

# Define the S3 bucket notification configuration to trigger the Lambda function on object creation events
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processing_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
    filter_suffix       = ".jpg"
  }
}

# Define the IAM role for the Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  # Assume role policy allowing Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

# Define the IAM policy for Lambda execution role with necessary permissions
resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "LambdaExecutionPolicy"
  description = "Policy for Lambda execution role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "iam:CreateRole",
          "iam:AttachRolePolicy",
          "iam:PutRolePolicy",
          # Add other necessary IAM actions
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:GetObject",
          "s3:PutObject",   
          "s3:ListBucket",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      # Add additional statements if needed
    ],
  })
}

# Attach necessary policies to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role.name
}
