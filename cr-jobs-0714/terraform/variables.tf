variable "project_id" {
  description = "gcp project name"
  type        = string
}
variable "region" {
  description = "location of resources"
  type        = string
  default     = "us-central1"
}
variable "container_path" {
  description = "The container image path for cloud run jobs"
  type        = string
}
variable "message" {
  description = "The message to be used"
  type        = string
  default     = "Hello World!"
}

variable "number" {
  description = "The number to be used"
  type        = number
  default     = 8
}
