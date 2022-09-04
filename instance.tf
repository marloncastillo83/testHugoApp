resource "google_compute_instance" "hugo-srv" {
  name                      = "${local.env}-${local.project}-hugosrv"
  machine_type              = "n1-standard-1"
  zone                      = "${local.region}-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-bionic-arm64-v20220901"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public.name

    access_config {
    }
  }

  tags = ["allow-web", "allow-ssh"]
}

output "hugosrv-nat-ip" {
  value = google_compute_instance.hugo-srv.network_interface.0.access_config.0.nat_ip
}

output "hugosrv-ip" {
  value = google_compute_instance.hugo-srv.network_interface.0.network_ip
}