FROM ubuntu:22.04

# Install dependencies
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y apache2 \
    php \
    npm \
    php-xml \
    php-mbstring \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    curl \
    git

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Setup project folder
RUN mkdir -p /var/www/sosmed
WORKDIR /var/www/sosmed

# Copy source code
ADD . /var/www/sosmed

# Apache config
ADD sosmed.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite sosmed.conf

# Setup Laravel folders & permissions
RUN mkdir -p bootstrap/cache storage/framework/{sessions,views,cache} && \
    chmod -R 755 storage/framework && \
    chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 775 bootstrap/cache storage
# Buat install.sh bisa dieksekusi
RUN chmod +x install.sh

# Jalankan install.sh (jika benar-benar perlu di build time) -
RUN ./install.sh || cat /var/www/sosmed/storage/logs/laravel.log || true

# Final permission
RUN chown -R www-data:www-data /var/www/sosmed && \
    chmod -R 755 /var/www/sosmed

EXPOSE 8000

# Gunakan CMD dalam bentuk JSON agar sinyal OS ditangani dengan benar
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"
