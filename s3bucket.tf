provider "aws" {
  region = "us-east-1"  #  AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "vivid-arts"  # Replace with your desired bucket name
  acl    = "private"  # ACL (Access Control List) for the bucket. "private" restricts access to the bucket owner.

  tags = {
    Name        = "MyS3Bucket"
    Environment = "Production"
  }
}
