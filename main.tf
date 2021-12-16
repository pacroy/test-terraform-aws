resource "aws_vpc" "test" {
  provider = aws.ec2_contributors
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "test" {
  provider = aws.s3_contributors
  bucket = "partestbucket"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "test" {
  provider = aws.s3_contributors
  bucket = aws_s3_bucket.test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
