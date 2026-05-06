resource "aws_glue_job" "b_to_s_etl" {
  name = "bronze-silver-etl-job"
  role_arn = aws_iam_role.glue_service_role.arn

  glue_version = "4.0"
  worker_type = "G.1X"
  number_of_workers = 2

  command {
    name = "glueetl"
    script_location = "s3://${aws_s3_bucket.glue_scripts.bucket}/*"
    python_version = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--continuous-log-logGroup" = "aws-glue/jobs/logs-v2/"
    "--enbable-continuous-cloudwatch-log" = "true"
    "--enable-metrics" = "true"
    "--TempDir" = "s3://${aws_s3_bucket.glue_scripts.bucket}/temp/"
  }

  max_retries = 0
  timeout = 2880

  tags = {
    Department = "Production"
  }
}

