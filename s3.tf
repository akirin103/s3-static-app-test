resource "aws_s3_bucket" "this" {
  bucket_prefix = "${var.system_name}-${var.env}-bucket"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      http_error_code_returned_equals = 404
    }
    redirect {
      replace_key_with = "404.html"
    }
  }
}

resource "aws_s3_object" "this" {
  for_each     = fileset("uploads/", "*.html")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "uploads/${each.value}"
  content_type = "text/html"
  etag         = filemd5("uploads/${each.value}")
}
