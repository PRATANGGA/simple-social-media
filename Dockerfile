FROM ubuntu:22.04

# Install dependencies
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    apache2 \
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

# Setup working directory
RUN mkdir -p /var/www/sosmed
WORKDIR /var/www/sosmed

# Copy source code
ADD . /var/www/sosmed

# Apache config
ADD sosmed.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite sosmed.conf

# Laravel required folders + permission
RUN mkdir -p bootstrap/cache \
    storage/framework/{sessions,views,cache} \
    storage/logs && \
    chown -R www-data:www-data bootstrap storage && \
    chmod -R 775 bootstrap storage

# Install.sh hanya ditandai executable — tidak dijalankan di build time
RUN chmod +x install.sh

EXPOSE 8000

# Command default
CMD ["apachectl", "-D", "FOREGROUND"]

