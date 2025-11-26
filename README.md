🌐 Multi-Cloud Failover using AWS + Route 53 + GCP
(Active-Passive Architecture with Automatic Failover)

This project demonstrates a multi-cloud failover setup where traffic is primarily served from AWS EC2 (NGINX), and upon failure, automatically fails over to GCP Compute Engine (NGINX) using Amazon Route 53 Failover Routing with Health Checks.

🚀 Architecture Overview

AWS EC2 (Primary Server)

Runs NGINX

Hosts /health endpoint

Route 53 monitors this server via health checks

Google Cloud Compute Engine (Secondary Server)

Runs NGINX

Hosts /health endpoint

Activated only when AWS fails

Amazon Route 53 (Failover DNS)

Primary A record → AWS Public IP

Secondary A record → GCP Public IP

Automatic failover based on health checks

Domain: subasangeeth.run.place

📘 Technologies Used
Component	Technology
Cloud Provider 1	AWS EC2, Route 53
Cloud Provider 2	Google Cloud Compute Engine
Web Server	NGINX
DNS Failover	Route 53 Health Checks
Automation	Bash Startup Scripts
Infrastructure	Terraform (optional)
🧩 Project Diagram
AWS EC2  →  Route 53  →  GCP Compute Engine
      (primary)        (failover)


When AWS is UP → Traffic served from AWS
When AWS goes DOWN → Route53 automatically switches to GCP

⚙️ Startup Scripts
AWS Startup Script
#!/bin/bash
set -e
PROVIDER="AWS"

# Install nginx
apt-get update -y || yum update -y
apt-get install -y nginx || yum install -y nginx
systemctl enable nginx

# Create health endpoint
echo "UP" > /var/www/html/health 2>/dev/null || echo "UP" > /usr/share/nginx/html/health

# Create HTML
WEBROOT="/var/www/html"
[[ ! -d $WEBROOT ]] && WEBROOT="/usr/share/nginx/html"

cat > ${WEBROOT}/index.html <<'HTML'
<html><body><h1>NGINX on $(hostname) - PROVIDER</h1></body></html>
HTML

sed -i "s/PROVIDER/$PROVIDER/g" ${WEBROOT}/index.html
systemctl restart nginx

GCP Startup Script
#!/bin/bash
set -e
PROVIDER="GCP"

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y nginx
  WEBROOT="/var/www/html"
else
  yum update -y
  yum install -y nginx
  WEBROOT="/usr/share/nginx/html"
fi

systemctl enable nginx
echo "UP" > "${WEBROOT}/health"

cat > "${WEBROOT}/index.html" <<'HTML'
<html><body><h1>NGINX on $(hostname) - PROVIDER</h1></body></html>
HTML

sed -i "s/PROVIDER/$PROVIDER/g" "${WEBROOT}/index.html"
systemctl restart nginx

🗂️ Route 53 Configuration
✔ Primary Record
Key	Value
Name	nginxx.subasangeeth.run.place
Type	A
Routing	Failover – Primary
Value	AWS Public IP
Health Check	Enabled
✔ Secondary Record
Key	Value
Name	nginxx.subasangeeth.run.place
Type	A
Routing	Failover – Secondary
Value	GCP Public IP
Health Check	Optional
🧪 Testing Failover
1️⃣ Check current DNS
dig +short nginxx.subasangeeth.run.place

2️⃣ Stop NGINX on AWS
sudo systemctl stop nginx

3️⃣ Wait for Route 53 health check

(usually 60–90 seconds)

4️⃣ DNS should now point to GCP
dig +short nginxx.subasangeeth.run.place

5️⃣ Access your domain
http://nginxx.subasangeeth.run.place

📈 Expected Behavior
Condition	Traffic Goes To
AWS Healthy	AWS EC2
AWS Down	GCP Compute Engine (Failover)
AWS Restored	Automatically back to AWS
🏁 Conclusion

This project implements a real-world multi-cloud failover architecture, ensuring high availability and resiliency using:

AWS EC2

GCP Compute Engine

Route 53 DNS Failover

NGINX health endpoints

Perfect for DevOps portfolios, cloud engineering practice, and disaster recovery learning.
