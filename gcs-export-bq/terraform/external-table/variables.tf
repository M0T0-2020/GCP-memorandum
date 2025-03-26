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
}

variable "table_id" {
  description = "The table id to be used"
  type        = string
}

variable "table_name" {
  description = "The table name to be used"
  type        = string
}

variable "gcs_bucket_name" {
  description = "The gcs bucket name to be used"
  type        = string
}
