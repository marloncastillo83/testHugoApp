resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.name
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

resource "google_compute_firewall" "http-server" {
  name    = "allow-web"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-web"]
}

resource "google_compute_firewall" "iap_to_ssh" {
  name    = "ingress-allow-iap-to-ssh"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  # Cloud IAP's TCP forwarding netblock
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-tunnel"]

  allow {
    protocol = "tcp"
    ports    = [22]
  }
}
