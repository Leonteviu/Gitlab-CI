resource "google_compute_instance" "vm" {
  name           = "gitlab-ci"
  machine_type   = "n1-standard-1"
  zone           = "europe-west1-b"
  tags           = ["http-server","https-server"]


  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.boot_disk_size}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.vm_ip.address}"
    }
  }

  metadata {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "vm_ip" {
  name = "vm-ip"
}
