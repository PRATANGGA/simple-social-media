#!/bin/bash
set -e

echo "▶️  Menjalankan setup aplikasi Laravel..."

# 1. Install dependencies Laravel dan JS
composer install 
npm install
npm run build

# 2. Setup .env
cp -n .env.example .env

# 3. Generate key
php artisan key:generate

# 4. Ganti koneksi DB (gunakan nama service, bukan IP statis)
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/' .env

# 5. Cache clear
php artisan config:clear
php artisan cache:clear
php artisan view:clear

# 6. Migrate dan seed
php artisan migrate --force
php artisan db:seed --force

# 7. Storage symlink
php artisan storage:link

echo "✅ Aplikasi Laravel siap dijalankan."

