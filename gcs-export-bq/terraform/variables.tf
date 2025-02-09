variable "project_id" {
  description = "gcp project name"
  type        = string
}
variable "region" {
  description = "location of resources"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "The dataset id to be used"
  type        = string
  default     = "test_dataset_1_20250209"
}

variable "table_id" {
  description = "The table id to be used"
  type        = string
  default     = "test_table_1_20250209"
}

variable "gcs_bucket_name" {
  description = "The gcs bucket name to be used"
  type        = string
  default     = "test_bucket_1_20250209"
}
