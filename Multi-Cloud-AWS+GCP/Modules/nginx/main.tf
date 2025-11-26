# --- AWS AMI lookup (Ubuntu Focal as example)
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# AWS Security Group (only created when cloud == "aws")
resource "aws_security_group" "allow_http" {
  count = var.cloud == "aws" ? 1 : 0
  name  = "tf-allow-http"
  description = "Allow HTTP inbound"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count         = var.cloud == "aws" ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = file("${path.root}/aws.sh")
  vpc_security_group_ids = length(aws_security_group.allow_http) > 0 ? [aws_security_group.allow_http[0].id] : []
  tags = { Name = "tf-nginx-aws" }
}

# GCP Firewall (only when cloud == "gcp")
resource "google_compute_firewall" "allow_http" {
  count    = var.cloud == "gcp" ? 1 : 0
  name     = "tf-allow-http"
  network  = "default"
  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "web" {
  count        = var.cloud == "gcp" ? 1 : 0
  name         = "tf-nginx-gcp"
  machine_type = var.instance_type
  zone         = var.gcp_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata_startup_script = file("${path.root}/gcp.sh")
  tags = ["http-server"]
}
