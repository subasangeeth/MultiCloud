variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "gcp_region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_zone" {
  description = "GCP zone"
  default     = "us-central1-a"
}

variable "aws_instance_type" {
  description = "AWS Instance Type"
  default     = "t2.micro"
}

variable "gcp_instance_type" {
  description = "GCP Instance Type"
  default     = "e2-micro"
}
