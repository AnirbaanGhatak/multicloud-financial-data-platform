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
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
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
        aws_s3_bucket.glue_scripts.arn,
        "${aws_s3_bucket.bronze_layer.arn}/*",
        "${aws_s3_bucket.silver_layer.arn}/*",
        "${aws_s3_bucket.glue_scripts.arn}/*"
    ]
  }

  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

}

resource "aws_iam_policy" "glue_policy" {
  name = "GlueAccessPolicy"
  description = "Allows Glue to access S3 and write logs"
  policy = data.aws_iam_policy_document.glue_permissions.json
}

resource "aws_iam_role_policy_attachment" "glue_attach" {
  role = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}

resource "aws_iam_role_policy_attachment" "glue_base_service" {
  role = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}






data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_service_role" {
  name               = "LambdaGlueJobRun"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {

    actions = [
      "glue:StartJobRun"
    ]

    resources = [
        
    ]
  }

  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
    ]
    resources = ["arn:aws:aws:logs:*:*:*"]
  }

}

resource "aws_iam_policy" "lambda_policy" {
  name = "LambdaGlueStartPolicy"
  description = "Allows Lambda to run Glue Job and write logs"
  policy = data.aws_iam_policy_document.lambda_permissions.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role = aws_iam_role.lambda_service_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn

}

resource "aws_iam_role_policy_attachment" "lambda_basic_service" {
  role = aws_iam_role.lambda_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
