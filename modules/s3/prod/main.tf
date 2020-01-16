variable "bucket_for_production" {}
variable "prod_user" {}


resource "aws_iam_user" "prod_user" {
    name = "${var.prod_user}"
}


resource "aws_iam_user_policy" "prod_user" {
    name = "tmn-mm-eq-prod-s3"
    user = "${aws_iam_user.prod_user.name}"
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::tmn-mm-eq-${var.bucket_for_production}",
                "arn:aws:s3:::tmn-mm-eq-${var.bucket_for_production}/*"
            ]
        }
    ]
}
EOF
}


resource "aws_s3_bucket" "production" {
  bucket = "tmn-mm-eq-${var.bucket_for_production}"
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
    Name        = "tmn-mm-eq-${var.bucket_for_production}"
    Environment = "${var.bucket_for_production}"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_user.prod_user.arn}"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::tmn-mm-eq-${var.bucket_for_production}",
                "arn:aws:s3:::tmn-mm-eq-${var.bucket_for_production}/*"
                ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "production" {
  bucket = "${aws_s3_bucket.production.id}"

  ignore_public_acls  = true
}
