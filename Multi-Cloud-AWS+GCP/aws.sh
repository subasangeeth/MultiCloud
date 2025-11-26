#!/bin/bash
set -e
PROVIDER="AWS"

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y nginx
  systemctl enable nginx

  echo "UP" > /var/www/html/health

  cat > /var/www/html/index.html <<'HTML'
<html>
<head>
<style>
  body {
    background: #f0f2f5;
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
  }
  .card {
    background: white;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    text-align: center;
  }
  h1 {
    color: #333;
    font-size: 28px;
  }
  .provider {
    margin-top: 10px;
    color: #555;
    font-size: 20px;
    font-weight: bold;
  }
</style>
</head>
<body>
  <div class="card">
    <h1>NGINX Server:</h1>
    <div class="provider">Provider: PROVIDER</div>
  </div>
</body>
</html>
HTML

  sed -i "s/PROVIDER/$PROVIDER/g" /var/www/html/index.html

  systemctl restart nginx

elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y nginx
  systemctl enable nginx

  echo "UP" > /usr/share/nginx/html/health

  cat > /usr/share/nginx/html/index.html <<'HTML'
<html>
<head>
<style>
  body {
    background: #f0f2f5;
    font-family: Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
  }
  .card {
    background: white;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    text-align: center;
  }
  h1 {
    color: #333;
    font-size: 28px;
  }
  .provider {
    margin-top: 10px;
    color: #555;
    font-size: 20px;
    font-weight: bold;
  }
</style>
</head>
<body>
  <div class="card">
    <h1>NGINX Server: </h1>
    <div class="provider">Provider: PROVIDER</div>
  </div>
</body>
</html>
HTML

  sed -i "s/PROVIDER/$PROVIDER/g" /usr/share/nginx/html/index.html

  systemctl restart nginx
fi
