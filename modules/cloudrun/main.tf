resource "google_cloud_run_v2_service" "default2" {
  name     = "q-pkg-cr-tr-backend"
  provider = google-beta
  location = var.region
#  id = "projects/prj-qa-workshop-poc/global/backendServices/backend-service2"
  project = "prj-qa-workshop-poc"
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  template {
    containers {
      ports {
        container_port = var.backend_container_port
      }
      image = "us-central1-docker.pkg.dev/prj-qa-workshop-poc/piyush-repo/backend:latest"
    }
  }
}

resource "google_cloud_run_v2_service" "default" {
  name     = "q-pkg-cr-tr-frontend"
    # id="projects/prj-qa-workshop-poc/locations/us-central1/services/q-pkg-cr-tr-frontend"
  provider = google-beta
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  project = "prj-qa-workshop-poc"

  template {
    containers {
      ports {
        container_port = var.frontend_container_port
      }
      image = var.cloud_run_frontend_image
      
    }
    vpc_access {

      connector = "projects/prj-qa-workshop-poc/locations/${var.region}/connectors/${var.vpc_connector}"
      egress    = "ALL_TRAFFIC"
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = var.run_policy_role
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth_frontend" {
  location    = google_cloud_run_v2_service.default.location
  project     = google_cloud_run_v2_service.default.project
  service     = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service_iam_policy" "noauth_backend" {
  location    = google_cloud_run_v2_service.default2.location
  project     = google_cloud_run_v2_service.default2.project
  service     = google_cloud_run_v2_service.default2.name
  policy_data = data.google_iam_policy.noauth.policy_data
  #
}

