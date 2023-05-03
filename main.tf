terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.63.1"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.63.1"
    }
  }
  required_version = "1.4.5"
}

provider "google" {
  project      = "ingka-sp-ordercapture-dev"
}

provider "google-beta" {
  project      = "ingka-sp-ordercapture-dev"
}


resource "google_cloud_run_service" "helloworldjs" {
  name     = "helloworldjs"
  location = "europe-west4"
  project = "ingka-sp-ordercapture-dev"

  template {
    spec {
      containers {
        image = "eu.gcr.io/ingka-sp-ordercapture-dev/devopsoclock/helloworldjs:v1"
      }
    }
  }
}

data "google_iam_policy" "allowall" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "allowall" {
  location    = google_cloud_run_service.helloworldjs.location
  project     = google_cloud_run_service.helloworldjs.project
  service     = google_cloud_run_service.helloworldjs.name

  policy_data = data.google_iam_policy.allowall.policy_data
}







