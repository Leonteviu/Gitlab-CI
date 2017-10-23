variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
  default     = "ubuntu-1604-xenial-v20171011"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable target_tags {
  description = "будет доступен только для инстансов с тегом ..."
  default     = ["http-server","https-server"]
}

variable boot_disk_size {
  default = 100
}
