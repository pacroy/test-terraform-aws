# Test Terraform for AWS

Test Terraform for AWS

## Prerequisites

- [Create an access key pair](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds-create), if you haven't done so.
- An S3 bucket for storing Terraform backend state files. You may create with this AWS CLI command:

    ```sh
    aws s3 mb s3://yours3bucket
    aws s3api put-public-access-block --bucket yours3bucket \
        --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
    ```

    If you want enable bucket versioning:

    ```sh
    aws s3api put-bucket-versioning --bucket yours3bucket \
        --versioning-configuration MFADelete=Disabled,Status=Enabled
    ```

## Usage

### Setup Credential

If you haven't [configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html), setup an access key pair using environment variables.

```sh
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

### Init

```sh
export AWS_DEFAULT_REGION="ap-southeast-1"
terraform init \
    -backend-config="bucket=yours3bucket" \
    -backend-config="key=test-terraform-aws/terraform.tfstate"
```

## Apply

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

If you enable bucket versioning, use [Empty Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/empty-bucket.html) on the S3 console. Otherwise, you can use this command:

```sh
aws s3 rm s3://yours3bucket --recursive
```

Now, delete the S3 bucket:

```
aws s3 rb s3://yours3bucket
```
