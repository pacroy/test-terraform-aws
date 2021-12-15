resource "aws_iam_policy" "terraform_partfbackend" {
  name        = "terraform_partfbackend"
  path        = "/"
  description = "Allow to use S3 and DynamoDB named partfbackend as Terraform backend"

  policy = file("${path.module}/terraform_partfbackend.json")
}

resource "aws_iam_policy" "deny_ec2_permissions" {
  name        = "deny_ec2_permissions"
  path        = "/"
  description = "Deny all EC2 permissions management actions"

  policy = file("${path.module}/deny_ec2_permissions.json")
}

resource "aws_iam_group" "terraform_partfbackend" {
  name = "terraform_partfbackend"
  path = "/users/"
}

resource "aws_iam_group" "vpc_contributor" {
  name = "vpc_contributor"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "terraform_partfbackend" {
  group      = aws_iam_group.terraform_partfbackend.name
  policy_arn = aws_iam_policy.terraform_partfbackend.arn
}

resource "aws_iam_group_policy_attachment" "vpc_contributor_deny_ec2_permissions" {
  group      = aws_iam_group.vpc_contributor.name
  policy_arn = aws_iam_policy.deny_ec2_permissions.arn
}

resource "aws_iam_group_policy_attachment" "vpc_contributor_vpc_fullaccess" {
  group      = aws_iam_group.vpc_contributor.name
  policy_arn = "aarn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user" "test_terraform_aws" {
  name = "test_terraform_aws"
  path = "/system/"
}

resource "aws_iam_access_key" "test_terraform_aws" {
  user = aws_iam_user.test_terraform_aws.name
}

resource "aws_iam_user_group_membership" "test_terraform_aws" {
  user = aws_iam_user.test_terraform_aws.name

  groups = [
    aws_iam_group.terraform_partfbackend.name,
    aws_iam_group.vpc_contributor.name,
  ]
}