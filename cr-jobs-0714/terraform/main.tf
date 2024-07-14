provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "project" {
    project_id = var.project_id
}

resource "google_service_account" "default" {
  account_id   = "cloud-run-jobs-test-sa"
  display_name = "service account for cr-jobs-0714"
}

resource "google_project_service" "cloudscheduler_api" {
  service = "cloudscheduler.googleapis.com"
}


resource "google_cloud_run_v2_job" "default" {
  name         = "cloud-run-job"
  location     = var.region
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = var.container_path
        env {
          name  = "MESSAGE"
          value = var.message
        }
        env {
          name  = "NUMBER"
          value = var.number
        }
      }
      # 3 hours
      timeout      = "10800s"
      service_account = google_service_account.default.email
    }
  }
}

resource "google_cloud_run_v2_job_iam_binding" "binding" {
  project  = google_cloud_run_v2_job.default.project
  name     = google_cloud_run_v2_job.default.name
  location = google_cloud_run_v2_job.default.location
  role     = "roles/run.invoker"

  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]
}

resource "google_cloud_scheduler_job" "job" {
  name             = "schedule-job"
  description      = "test http job"
  schedule         = "0 10 * * *" # execute every day at 7pm(jst)
  attempt_deadline = "320s"
  region           = var.region
  project          = var.project_id

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.default.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.project.number}/jobs/${google_cloud_run_v2_job.default.name}:run"

    oauth_token {
      service_account_email = google_service_account.default.email
    }
  }

  depends_on = [
    resource.google_project_service.cloudscheduler_api,
    resource.google_cloud_run_v2_job.default,
    resource.google_cloud_run_v2_job_iam_binding.binding
  ]
}