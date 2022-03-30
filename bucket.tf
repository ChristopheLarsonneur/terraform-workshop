resource "aws_s3_bucket" "tfstate" {
  bucket = "m6-tfstate-ws${var.workshop_id}"

  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.tfstate.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_account_public_access_block" "bucket_account_access_block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "tfstate_bucket_public_access" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

// Build policy document from terraform_bucket.policies
data "aws_iam_policy_document" "terraform_bucket_policy" {

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/OrganizationAccountAccessRole",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/workshop-user"
      ]
    }

    resources = [aws_s3_bucket.tfstate.arn]

  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/OrganizationAccountAccessRole",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/workshop-user"
      ]
    }

    resources = ["${aws_s3_bucket.tfstate.arn}/*"]

  }

}

resource "aws_s3_bucket_policy" "terraform_bucket_policy" {
  bucket = aws_s3_bucket.tfstate.id

  policy = data.aws_iam_policy_document.terraform_bucket_policy.json
}