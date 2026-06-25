#!/bin/bash
endpoint="${db_endpoint}"
user="${db_user}"
password="${db_password}"
database="${db_database}"
token="${git_token}"

sudo yum update -y
sudo yum install -y docker git
sudo systemctl start docker
sudo systemctl enable docker
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo rpm -Uvh https://repo.mysql.com/mysql57-community-release-el7.rpm
sudo yum install mysql-community-client -y

GIT_REPO_URL="https://$${token}@github.com/ORT-FI-7417-SolucionesCloud/e-commerce-obligatorio-2025.git"
git clone "$${GIT_REPO_URL}"
mysql -h "$${endpoint}" -u "$${user}" -p"$${password}" "$${database}" < e-commerce-obligatorio-2025/db-settings.sql

sudo docker run -d \
    --name php-ecommerce \
    -p 80:80 \
    -e DB_HOST="$${endpoint}" \
    -e DB_USER="$${user}" \
    -e DB_PASS="$${password}" \
    -e DB_NAME="$${database}" \
    seba904/php-ecommerce:latest