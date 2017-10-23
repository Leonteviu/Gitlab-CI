provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

module "vm" {
  source          = "modules/vm"
  public_key_path = "${var.public_key_path}"
  disk_image  = "${var.disk_image}"
}

module "vpc" {
  source = "modules/vpc"
}
