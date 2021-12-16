# Test Terraform for AWS

Test Terraform for AWS

## Prerequisites

### Create IAM User, Group, Policies, and Roles

This will create the following AWS IAM resources:

- User `test_terraform_aws` and add to group `terraform_users`
- Group `terraform_users` and attach the the following policy:
  - `allow_getuser_self`: this allows to get self user information
  - `allow_assume_contributor_roles`: this allows to assume any contributors roles
  - `terraform_partfbackend`: this allows sufficient access to S3 and DynomoDB table for Terraform backend state handling
- Role `ec2_contributors` which can be assumed by account root and attach the the following policy:
  - `AmazonEC2FullAccess`: Built-in role to provide full access to Amazon EC2
  - `deny_ec2_permissions`: this denies all EC2 permision management actions
- Role `s3_contributors` which can be assumed by account root and attach the the following policy:
  - `AmazonS3FullAccess`: Built-in role to provide full access to all S3 buckets
  - `deny_s3_permissions`: this denies all S3 permision management actions except `PutBucketPublicAccessBlock`

Before execute the command below, you need to [configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) with an access key of AWS user with permissions to create IAM resources.

```sh
(cd aws-iam && terraform init && terraform apply)   # Enter `yes` to confirm
```

Display the access key id and secret key of the newly-created user:

```sh
(cd aws-iam && tf output -json access_key | jq)
```

You may configure a separated profile for the new user:

```sh
aws configure --profile test_terraform_aws
```

### Create a S3 Bucket

An S3 bucket for storing Terraform backend state files. You may create with these AWS CLI commands:

```sh
aws s3 mb s3://partfbackend

# This disable public access
aws s3api put-public-access-block --bucket partfbackend \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# This enable server-side encryption
aws s3api put-bucket-encryption --bucket partfbackend \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"},"BucketKeyEnabled":true}]}'
```

If you want enable bucket versioning:

```sh
aws s3api put-bucket-versioning --bucket partfbackend \
    --versioning-configuration MFADelete=Disabled,Status=Enabled
```

### Create DynamoDB Table

A DynamoDB table for Terraform to support state locking. You may create with these AWS CLI commands:

```sh
aws dynamodb create-table \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --table-name partfbackend \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PROVISIONED \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

## Usage

### Setup Credential

If you haven't [configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html), setup an access key pair using environment variables.

```sh
export AWS_ACCESS_KEY_ID="<access_key>"
export AWS_SECRET_ACCESS_KEY="<secret_key>"
```

### Init

If you want to use specific AWS CLI configuration profile, set `AWS_PROFILE` environment variable:

```sh
export AWS_PROFILE="test_terraform_aws"
```

Set the region and run Terraform Init.

```sh
export AWS_DEFAULT_REGION="ap-southeast-1"
terraform init \
    -backend-config="bucket=partfbackend" \
    -backend-config="key=path/to/terraform.tfstate" \
    -backend-config="dynamodb_table=partfbackend"
```

### Apply

```sh
terraform apply
```

You may check the newly-created VPC using AWS CLI:

```sh
aws ec2 describe-vpcs --filter Name=vpc-id,Values=$(tf output -json vpc | jq -r ".id")
```

### Destroy

```sh
terraform destroy -auto-approve
```

## Cleanup

### S3 Bucket

If you enable bucket versioning, use [Empty Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html) on the S3 console. Otherwise, you can use this command:

```sh
aws s3 rm s3://partfbackend --recursive
```

Now, delete the S3 bucket:

```sh
aws s3 rb s3://partfbackend
```

### DynamoDB Table

```sh
aws dynamodb delete-table --table-name partfbackend
```

### Delete IAM User, Group, Policies, and Roles

```sh
(cd aws-iam && tf destroy --auto-approve)
```
