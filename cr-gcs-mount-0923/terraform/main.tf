provider "google" {
  project = var.project
  region  = var.region
}

# GCSバケットの作成
resource "google_storage_bucket" "default" {
  name     = var.storage_name
  location = var.region
  force_destroy = true
}

# Cloud Run サービス用のサービスアカウント
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
}

# サービスアカウントにGCSアクセス権限を付与
resource "google_project_iam_member" "storage" {
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
# Cloud Run サービスの作成
resource "google_cloud_run_v2_service" "service" {
  depends_on = [google_storage_bucket.default]
  name       = "gcs-fuse-sample-${random_id.bucket_suffix.hex}"
  location   = var.region
  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run_sa.email
    timeout         = "3.5s"


    containers {
      image = var.image_path
      env {
        name  = "MOUNTPATH"
        value = var.mount_path
      }
      volume_mounts {
        name       = "bucket"
        mount_path = var.mount_path
      }
      ports {
        container_port = 8080
      }
    }

    volumes {
      name = "bucket"
      gcs {
        bucket    = google_storage_bucket.default.name
        read_only = false
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"
}
