provider "google" {
  project = var.project
  region  = var.region
}

# GCSバケットの作成
resource "google_storage_bucket" "default" {
  name          = var.storage_name
  location      = var.region
  force_destroy = true # 実験なので、消せるようにする
}

# Cloud Run サービス用のサービスアカウント
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa-261024"
  display_name = "Cloud Run Service Account"
}

# サービスアカウントにGCSアクセス権限を付与
resource "google_project_iam_member" "storage" {
  project = var.project
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Cloud Run サービスの作成
resource "google_cloud_run_v2_service" "service" {
  depends_on = [google_storage_bucket.default]
  name       = "langflow-test"
  location   = var.region
  # 実験なので、消せるようにする
  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run_sa.email
    timeout         = "120s"
    containers {
      image = var.image_path
      volume_mounts {
        name       = var.volume_name
        mount_path = "/app/langflow-storage"
      }
      ports {
        container_port = 7860
      }
      resources {
        limits = {
          "memory" = "4Gi"
          "cpu"    = "6"
        }
      }
    }

    volumes {
      name = var.volume_name
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

resource "google_cloud_run_v2_service_iam_member" "member" {
  project  = google_cloud_run_v2_service.service.project
  location = google_cloud_run_v2_service.service.location
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}