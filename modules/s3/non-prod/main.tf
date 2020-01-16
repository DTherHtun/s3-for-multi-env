variable "buckets_non_prod_env" { type = "list" }
variable "non_prod_user" {}


resource "aws_iam_user" "non_prod_user" {
    name = "${var.non_prod_user}"
}


resource "aws_iam_user_policy" "non_prod_user" {
    name = "tmn-mm-eq-non-prod-s3"
    user = "${aws_iam_user.non_prod_user.name}"
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[0]}/*",
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[1]}/*",
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[2]}/*",
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[3]}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "non_production" {
  count  = "${length(var.buckets_non_prod_env)}"
  bucket = "tmn-mm-eq-${var.buckets_non_prod_env[count.index]}"
  acl    = "private"

  versioning {
    enabled = true
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "tmn-mm-eq-${var.buckets_non_prod_env[count.index]}"
    Environment = "${var.buckets_non_prod_env[count.index]}"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.non_prod_user.arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[count.index]}",
                "arn:aws:s3:::tmn-mm-eq-${var.buckets_non_prod_env[count.index]}/*"
                ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "non_production" {
  count  = "${length(var.buckets_non_prod_env)}"
  bucket = "tmn-mm-eq-${var.buckets_non_prod_env[count.index]}"

  ignore_public_acls  = true
}
