#!/bin/bash

set -e

# Install dependencies
composer install
npm install
npm run build

# Setup Laravel
cp .env.example .env
php artisan key:generate

# Update koneksi DB (optional, sesuaikan IP-nya)
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.2/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/' .env

# Clear and rebuild cache
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# Migrate dan seed
php artisan migrate --force
php artisan db:seed --force

# Buat symbolic link ke storage
php artisan storage:link

