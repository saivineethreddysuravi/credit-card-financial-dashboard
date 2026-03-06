# Infrastructure as Code for Credit Risk Analytics
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for raw transaction data lake
resource "aws_s3_bucket" "credit_risk_data_lake" {
  bucket = "enterprise-credit-risk-datalake-prod"
}

# IAM Role for Snowflake integration
resource "aws_iam_role" "snowflake_integration_role" {
  name = "snowflake_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root" # Example Snowflake Account ID
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "snowflake_s3_access" {
  role       = aws_iam_role.snowflake_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
