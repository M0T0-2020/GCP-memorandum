resource "google_bigquery_table" "table" {
  project    = var.project_id
  dataset_id = var.dataset_id
  # テーブルIDを指定
  table_id = var.table_id
  # テストなので、テーブルを誤削除の保護はしない。
  deletion_protection = false

  external_data_configuration {
    autodetect            = false
    ignore_unknown_values = false
    max_bad_records       = 0
    hive_partitioning_options {
      mode                     = "CUSTOM"
      source_uri_prefix        = "gs://${var.gcs_bucket_name}/{id:STRING}/"
      require_partition_filter = false
    }
    csv_options {
      quote                 = "\""
      skip_leading_rows     = 1
      allow_quoted_newlines = true
      # allow_jagged_rows を入れることで CSV の列数が異なる場合、つまりカラムが足りないCSVがある場合でもエラーが出ない
      allow_jagged_rows = true
    }
    # スキーマファイルのパスを指定
    schema        = file("../bq_schema/${var.table_name}.json")
    source_format = "CSV"
    source_uris   = ["gs://${var.gcs_bucket_name}/*"]
  }
}


resource "google_bigquery_table" "view" {
  project    = var.project_id
  dataset_id = var.dataset_id
  table_id   = "${var.table_id}_view"
  # テストなので、テーブルを誤削除の保護はしない。
  deletion_protection = false

  view {
    query = templatefile("../bq_schema/${var.table_name}_view.tftpl", {
      gcs_project_name = var.project_id,
      dataset_id       = var.dataset_id,
      table_id         = var.table_id
    })
    use_legacy_sql = false
  }
}
