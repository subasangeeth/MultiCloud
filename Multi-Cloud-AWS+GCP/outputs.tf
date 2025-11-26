output "aws_public_ip" {
  value = module.aws_nginx.public_ip
  description = "Public IP of AWS instance (empty string if none)"
}

output "gcp_public_ip" {
  value = module.gcp_nginx.public_ip
  description = "Public IP of GCP instance (empty string if none)"
}
