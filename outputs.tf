output "bucket_name" {
  description = "Bucket name for my static website"
  value = module.terrahouse_aws.bucket_name
}