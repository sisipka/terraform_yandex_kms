output "bucket_domain_name" {
  value = "http://${yandex_storage_bucket.my-bucket.bucket_domain_name}/devops.jpg"
}