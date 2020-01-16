provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"  # e.g. eu-west-1
    version = "~> 2.44"
}
