# Test Terraform for AWS

Test Terraform for AWS

## Usage

```sh
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-1"
terraform init \
    -backend-config="bucket=yours3bucket" \
    -backend-config="key=test-terraform-aws/terraform.tfstate"
terraform plan
```
