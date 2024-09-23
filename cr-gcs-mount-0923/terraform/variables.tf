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
  default     = "fuse-test-bucket"
}

variable "mount_path" {
  description = "instance mount path"
  type        = string
  default     = "/mnt/gcs-bucket"
}

variable "image_path" {
  description = "docker image path"
  type        = string
}

variable "user_email" {
  description = "user email"
  type        = string
}