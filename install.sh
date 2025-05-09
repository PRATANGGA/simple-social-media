#!/bin/bash

set -e  # Stop skrip kalau ada error

echo "📦 Installing Node & PHP dependencies..."
npm install
npm run dev

composer install

echo "🔐 Setting up Laravel environment..."
cp -n .env.example .env || true
php artisan key:generate

echo "⚙️ Configuring .env database..."
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=172.17.0.2/g' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env

echo "🧹 Clearing and updating Laravel..."
php artisan config:clear || true
php artisan cache:clear || true
composer update

echo "🗄️ Running migrations and seeding database..."
php artisan migrate --force
php artisan db:seed --force

echo "🔗 Linking storage..."
php artisan storage:link || true

echo "📂 Fixing permissions..."
mkdir -p bootstrap/cache storage/framework/{sessions,views,cache}
chmod -R 775 bootstrap/cache storage
chown -R www-data:www-data bootstrap storage

echo "✅ install.sh completed successfully!"

