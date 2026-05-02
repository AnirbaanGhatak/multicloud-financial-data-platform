output "bronze_bucket_arn" {
  value = aws_s3_bucket.bronze_layer.arn
}

output "silver_bucket_arn" {
  value = aws_s3_bucket.silver_layer.arn
}

output "glue_scripts_bucket_arn" {
  value = aws_s3_bucket.glue_scripts.arn
}

output "bronze_layer" {
  value = aws_s3_bucket.bronze_layer.bucket
}

output "silver_layer" {
  value = aws_s3_bucket.silver_layer.bucket
}

output "glue_scripts_layer" {
  value = aws_s3_bucket.glue_scripts.bucket
}