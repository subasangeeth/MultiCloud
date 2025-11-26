output "public_ip" {
  value = (
    length(aws_instance.web) > 0 ? aws_instance.web[0].public_ip :
    (length(google_compute_instance.web) > 0 ? google_compute_instance.web[0].network_interface[0].access_config[0].nat_ip : "")
  )
  description = "Public IP (AWS or GCP) depending on cloud"
}
