variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPリージョン"
  type        = string
  default     = "us-central1"
}

variable "storage_name" {
  description = "storage name to be mounted"
  type        = string
  default     = "fuse-test-bucket-20241031"
}

variable "image_path" {
  description = "docker image path"
  type        = string
}

variable "volume_name" {
  default = "bucket"
}