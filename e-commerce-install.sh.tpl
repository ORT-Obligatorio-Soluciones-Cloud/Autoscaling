#!/bin/bash
endpoint="${db_endpoint}"
user="${db_user}"
password="${db_password}"
database="${db_database}"
token="${git_token}"

sudo yum update -y
sudo yum install -y git docker mariadb105-org-client
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull seba904/php-ecommerce:latest

cd /tmp 
GIT_REPO_URL="https://$${token}@github.com/ORT-FI-7417-SolucionesCloud/e-commerce-obligatorio-2025.git"
git clone "$${GIT_REPO_URL}" 

until mysql -h "$${endpoint}" -u "$${user}" -p"$${password}" "$${database}" -e "SELECT 1" >/dev/null; do
    sleep 5
done

mariadb -h "$${endpoint}" -u "$${user}" -p"$${password}" "$${database}" < /tmp/e-commerce-obligatorio-2025/db-settings.sql 

sudo docker rm -f php-ecommerce || true
sudo docker run -d \
    --name php-ecommerce \
    -p 80:80 \
    --restart always \
    -e DB_HOST="$${endpoint}" \
    -e DB_USER="$${user}" \
    -e DB_PASS="$${password}" \
    -e DB_NAME="$${database}" \
    seba904/php-ecommerce:latest