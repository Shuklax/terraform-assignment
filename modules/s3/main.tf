
resource "aws_s3_bucket" "this" {
  bucket = lower("${var.project_name}-bucket-${random_id.bucket_id.hex}")
  acl    = "private"

  lifecycle_rule {
    id      = "move-to-ia"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 3650 # keep for a long time; modify if needed
    }
  }

  tags = { Name = var.project_name }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}