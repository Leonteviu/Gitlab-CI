resource "google_compute_firewall" "firewall_http" {
  name = "default-allow-http"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = "${var.source_ranges}"
  target_tags = "${var.target_tags}"
}

resource "google_compute_firewall" "firewall_https" {
  name = "default-allow-https"

  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = "${var.source_ranges}"
  target_tags = "${var.target_tags}"
}
