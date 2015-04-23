variable "aws_access_key" {}
output "aws_access_key" {
    value = "${var.aws_access_key}"
}

variable "aws_secret_key" {}
output "aws_secret_key" {
    value = "${var.aws_secret_key}"
}

variable "aws_region" {
    default = "us-west-1"
}
output "aws_region" {
    value = "${var.aws_region}"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
    bucket = "cbjohnson-os-artifacts"
    acl = "public-read"
}

output "aws_s3_bucket" {
    value = "${aws_s3_bucket.bucket.bucket}"
}
