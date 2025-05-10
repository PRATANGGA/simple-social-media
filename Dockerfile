FROM ubuntu:22.04

# Install dependencies
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    apache2 \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    curl \
    git \
    npm

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Buat direktori project
RUN mkdir -p /var/www/sosmed
WORKDIR /var/www/sosmed

# Copy project source code
COPY . .

# Apache config
COPY sosmed.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite sosmed.conf

# Laravel folders and permissions
RUN mkdir -p bootstrap/cache storage/framework/{sessions,views,cache} storage/logs && \
    chown -R www-data:www-data . && \
    chmod -R 775 bootstrap storage

# Jalankan install.sh
RUN chmod +x install.sh && ./install.sh

# Expose port Laravel (digunakan php artisan serve)
EXPOSE 8000

# Default CMD
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

