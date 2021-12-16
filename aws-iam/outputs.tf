output "user" {
  description = "AWS IAM User test_terraform_aws"
  value       = aws_iam_user.test_terraform_aws
}

output "access_key" {
  description = "Access Key of user test_terraform_aws"
  value       = aws_iam_access_key.test_terraform_aws
  sensitive   = true
}
