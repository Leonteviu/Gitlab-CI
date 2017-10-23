output "vm_external_ip" {
  value = "${google_compute_instance.vm.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "vm_internal_ip" {
  value = "${google_compute_instance.vm.network_interface.0.address}"
}
