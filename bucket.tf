resource "yandex_iam_service_account" "sa" {
  name = "sa-storage"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "my-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl           = "public-read"
  bucket        = "shestihin"
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id = yandex_kms_symmetric_key.key-a.id
            sse_algorithm     = "aws:kms"
        }
    }
    }
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "image-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  acl        = "public-read"
  bucket     = "shestihin"
  key        = "devops.jpg"
  source     = "./pic/devops.jpg"
  depends_on = [
    yandex_storage_bucket.my-bucket
  ]
}