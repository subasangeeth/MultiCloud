terraform {
  required_version = ">= 1.4"
  required_providers {
    aws    = { source = "hashicorp/aws" }
    google = { source = "hashicorp/google" }
  }
}

provider "aws" {
  region = var.aws_region
  # Credentials: AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY or shared credentials
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  # Credentials: set GOOGLE_CREDENTIALS env or gcloud auth
}

module "aws_nginx" {
  source        = "./Modules/nginx"
  providers     = { aws = aws, google = google }
  cloud         = "aws"
  instance_type = var.aws_instance_type
  aws_region    = var.aws_region
  gcp_zone      = var.gcp_zone
}

module "gcp_nginx" {
  source        = "./Modules/nginx"
  providers     = { aws = aws, google = google }
  cloud         = "gcp"
  instance_type = var.gcp_instance_type
  aws_region    = var.aws_region
  gcp_zone      = var.gcp_zone
}
