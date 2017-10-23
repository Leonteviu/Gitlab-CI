variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable target_tags {
  description = "Allowed servers"
  default     = ["http-server","https-server"]
}
