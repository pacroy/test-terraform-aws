resource "aws_iam_policy" "allow_getuser_self" {
  name        = "allow_getuser_self"
  path        = "/"
  description = "Allow to get self user information"

  policy = file("${path.module}/allow_getuser_self.json")
}

resource "aws_iam_policy" "allow_assume_any_roles" {
  name        = "allow_assume_any_roles"
  path        = "/"
  description = "Allow to assume any roles"

  policy = file("${path.module}/allow_assume_any_roles.json")
}

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

resource "aws_iam_group" "terraform_users" {
  name = "terraform_users"
  path = "/users/"
}

resource "aws_iam_group" "vpc_contributors" {
  name = "vpc_contributors"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "allow_getuser_self" {
  group      = aws_iam_group.terraform_users.name
  policy_arn = aws_iam_policy.allow_getuser_self.arn
}

resource "aws_iam_group_policy_attachment" "allow_assume_any_roles" {
  group      = aws_iam_group.terraform_users.name
  policy_arn = aws_iam_policy.allow_assume_any_roles.arn
}

resource "aws_iam_group_policy_attachment" "terraform_partfbackend" {
  group      = aws_iam_group.terraform_users.name
  policy_arn = aws_iam_policy.terraform_partfbackend.arn
}

resource "aws_iam_group_policy_attachment" "deny_ec2_permissions" {
  group      = aws_iam_group.vpc_contributors.name
  policy_arn = aws_iam_policy.deny_ec2_permissions.arn
}

resource "aws_iam_group_policy_attachment" "amazonvpcfullaccess" {
  group      = aws_iam_group.vpc_contributors.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
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
    aws_iam_group.terraform_users.name,
    aws_iam_group.vpc_contributors.name,
  ]
}