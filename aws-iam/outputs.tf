output "policy_terraform_partfbackend" {
  description = "AWS IAM Policy terraform_partfbackend"
  value       = aws_iam_policy.terraform_partfbackend
}

output "policy_deny_ec2_permissions" {
  description = "AWS IAM Policy deny_ec2_permissions"
  value       = aws_iam_policy.deny_ec2_permissions
}

output "group_aws_iam_group" {
  description = "AWS IAM Group terraform_partfbackend"
  value       = aws_iam_group.terraform_partfbackend
}

output "group_vpc_contributor" {
  description = "AWS IAM Group vpc_contributor"
  value       = aws_iam_group.vpc_contributor
}

output "user_test_terraform_aws" {
  description = "AWS IAM User test_terraform_aws"
  value       = aws_iam_user.test_terraform_aws
}

output "access_key_test_terraform_aws" {
  description = "Access Key of user test_terraform_aws"
  value       = aws_iam_access_key.test_terraform_aws
  sensitive   = true
}