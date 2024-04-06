resource "google_compute_network" "vpc-cr-lb" {
  name                    = var.network_name
  auto_create_subnetworks = true
  # routing_mode = "REGIONAL"
  project = var.project
}

resource "google_compute_firewall" "allow-http7" {
  name    = "allow-http1"
  network = google_compute_network.vpc-cr-lb.name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = [var.http_port]
  }

  source_ranges = var.http_source_ranges
}

resource "google_compute_firewall" "allow-https7" {
  name    = "allow-https1"
  network = google_compute_network.vpc-cr-lb.name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = [var.https_port]
  }

  source_ranges = var.https_source_ranges
}

resource "google_compute_subnetwork" "vpc-sub77" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_ip_cidr
  region        = var.region
  network       = google_compute_network.vpc-cr-lb.id
  project = var.project
}

resource "google_vpc_access_connector" "svpc-connector" {
  name          = "serverlesscon"
  network       = google_compute_network.vpc-cr-lb.name
  ip_cidr_range = var.vpc_connector_ip_cidr
  project       = var.vpc_connector_project
  region        = var.vpc_connector_location
 #
}
