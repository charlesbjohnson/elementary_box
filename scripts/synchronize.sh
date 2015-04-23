#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID=$(terraform output -state=./terraform/terraform.tfstate aws_access_key)
export AWS_SECRET_ACCESS_KEY=$(terraform output -state=./terraform/terraform.tfstate aws_secret_key)

AWS_S3_BUCKET=$(terraform output -state=./terraform/terraform.tfstate aws_s3_bucket)
AWS_REGION=$(terraform output -state=./terraform/terraform.tfstate aws_region)

aws --region "$AWS_REGION" s3 sync ~/app/artifacts "s3://$AWS_S3_BUCKET"
aws --region "$AWS_REGION" s3 sync "s3://$AWS_S3_BUCKET" ~/app/artifacts

echo 'Artifact synchronization finished'
