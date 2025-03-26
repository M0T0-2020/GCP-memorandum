resource "google_storage_bucket" "bucket" {
  project       = var.project_id
  name          = var.gcs_bucket_name
  location      = var.region
  force_destroy = true
  # バケットレベルでのアクセス制御を有効にする (推奨)
  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "dataset" {
  project    = var.project_id
  dataset_id = var.dataset_id
  location   = var.region
}

module "table1" {
  depends_on = [google_storage_bucket.bucket, google_bigquery_dataset.dataset]
  source     = "./external-table"

  project_id      = var.project_id
  region          = var.region
  dataset_id      = var.dataset_id
  table_id        = "table1"
  gcs_bucket_name = var.gcs_bucket_name
  table_name      = "test_table"
}
