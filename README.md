# Test Terraform for AWS

Test Terraform for AWS

## Prerequisites

### Create a New User and Access Key

Create a new user and an access key pair using these AWS CLI commands:

```sh
aws iam create-user --user-name a-user-name
aws iam create-access-key --user-name a-user-name
```

Make sure you make note of AccessKeyId and SecretAccessKey as it appears only once.

### Create a S3 Bucket

An S3 bucket for storing Terraform backend state files. You may create with these AWS CLI commands:

```sh
aws s3 mb s3://yours3bucket

# This disable public access
aws s3api put-public-access-block --bucket yours3bucket \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# This enable server-side encryption
aws s3api put-bucket-encryption --bucket yours3bucket \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"},"BucketKeyEnabled":true}]}'
```

If you want enable bucket versioning:

```sh
aws s3api put-bucket-versioning --bucket yours3bucket \
    --versioning-configuration MFADelete=Disabled,Status=Enabled
```

### Create DynamoDB Table

A DynamoDB table for Terraform to support state locking. You may create with these AWS CLI commands:

```sh
aws dynamodb create-table \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --table-name yourtablename \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PROVISIONED \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

## Usage

### Setup Credential

If you haven't [configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html), setup an access key pair using environment variables.

```sh
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

### Init

If you want to use specific AWS CLI configuration profile, set `AWS_PROFILE` environment variable:

```sh
export AWS_PROFILE="anawsprofile"
```

Set the region and run Terraform Init.

```sh
export AWS_DEFAULT_REGION="ap-southeast-1"
terraform init \
    -backend-config="bucket=yours3bucket" \
    -backend-config="key=test-terraform-aws/terraform.tfstate" \
    -backend-config="dynamodb_table=yourtablename"
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
aws s3 rm s3://yours3bucket --recursive
```

Now, delete the S3 bucket:

```sh
aws s3 rb s3://yours3bucket
```

### DynamoDB Table

```sh
aws dynamodb delete-table --table-name yourtablename
```
