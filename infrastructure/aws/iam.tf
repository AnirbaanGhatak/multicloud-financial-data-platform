data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue_service_role" {
  name               = "GlueS3andLogsRole"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role
}

data "aws_iam_policy_document" "glue_permissions" {
  statement {

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
        aws_s3_bucket.bronze_layer.arn,
        aws_s3_bucket.silver_layer.arn,
        aws_s3_bucket.glue_scripts.arn
    ]
  }

  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
    ]
    resources = []
  }


}
