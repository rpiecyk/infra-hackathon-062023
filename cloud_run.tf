module "lb_http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 9.0"

  project = var.hackathon_project
  name    = "backend-https-global-lb"

  ssl                             = true
  managed_ssl_certificate_domains = ["be.todamiro.com"]
  https_redirect                  = true
  backends = {
    default = {
      description             = null
      protocol                = "HTTP"
      port_name               = "http"
      enable_cdn              = false
      custom_request_headers  = null
      custom_response_headers = null
      security_policy         = null
      edge_security_policy    = null
      compression_mode        = null

      log_config = {
        enable      = false
        sample_rate = null
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.todamiro_backend_neg.id
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "todamiro_backend_neg" {
  provider              = google-beta
  project               = var.hackathon_project
  name                  = "todamiro-backend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.main_region
  cloud_run {
    service = google_cloud_run_service.todamiro_backend.name
  }
}

module "serverless_connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version    = "~> 7.0"
  project_id = var.hackathon_project
  vpc_connectors = [{
    name           = "west1-serverless"
    region         = var.main_region
    subnet_name    = local.serverless_subnet_name
    machine_type   = "f1-micro"
    min_instances  = 2
    max_instances  = 5
    max_throughput = 500
  }]

  depends_on = [google_project_service.api_service["vpcaccess.googleapis.com"]]
}

resource "google_cloud_run_service" "todamiro_backend" {
  name     = "todamiro-backend"
  provider = google-beta
  project  = var.hackathon_project
  location = google_artifact_registry_repository.todamiro_backend.location

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "all"
    }
  }

  template {
    spec {
      containers {
        image = "europe-west1-docker.pkg.dev/hackathon-team-1-388910/todamiro-backend/main:b24cdcc1f3aacfc5c11d83fd4774b2ef8e74cb3e"
        ports {
          container_port = 3001
        }
        resources {
          limits = {
            cpu    = "1000m"
            memory = "512M"
          }
        }
        startup_probe {
          failure_threshold     = 5
          initial_delay_seconds = 10
          http_get {
            path = "/"
            port = 3001
          }
        }
      }
      # the service uses this SA to call other Google Cloud APIs
      # service_account_name = myservice_runtime_sa
    }

    metadata {
      labels = {
        "run.googleapis.com/startupProbeType" = "Custom"
      }
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "20"
        "run.googleapis.com/vpc-access-connector" = tolist(module.serverless_connector.connector_ids)[0]
        # all egress from the service should go through the VPC Connector
        "run.googleapis.com/vpc-access-egress" = "private-ranges-only"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "public-access" {
  location = google_cloud_run_service.todamiro_backend.location
  project  = google_cloud_run_service.todamiro_backend.project
  service  = google_cloud_run_service.todamiro_backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}