provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_service_account" "function_sa" {
  account_id   = "cloud-functions-test-sa"
  display_name = "Cloud Functions Service Account"
}


resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.function_sa.email}"

}

# ローカルソースディレクトリをZIP化する
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../function-source"
  output_path = "${path.module}/../build/function.zip"
}

# Cloud Functions 用のGCSバケットを作成（既存のバケットがある場合は省略可）
resource "google_storage_bucket" "function_bucket" {
  name          = "cloud-functions-bucket-test-0323"
  location      = var.region
  storage_class = "REGIONAL"
}

# ZIPファイルをGCSバケットへアップロード
resource "google_storage_bucket_object" "function_zip_obj" {
  # apply ごとに異なるファイル名を生成するため、MD5ハッシュを利用
  name   = "function-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}

# Cloud Function のデプロイ
resource "google_cloudfunctions2_function" "function" {
  depends_on  = [google_storage_bucket_object.function_zip_obj]
  project     = var.project_id
  name        = "my-function"
  location    = var.region
  description = "My Cloud Function deployed via Terraform"
  build_config {
    runtime     = "python311"
    entry_point = "compute_logger_test"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_zip_obj.name
      }
    }
  }

  service_config {
    service_account_email = google_service_account.function_sa.email
    max_instance_count    = 1
    available_memory      = "128Mi"
    timeout_seconds       = 60
  }
}
