FROM php:8.2-apache

# Ustaw DocumentRoot na katalog /public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# Instalacja zależności systemowych
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    nodejs \
    npm \
    gnupg \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

# Instalacja Composera (globalnie)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Skopiuj własny plik konfiguracyjny Apache do kontenera
COPY docker/apache/laravel.conf /etc/apache2/sites-available/laravel.conf

# Konfiguracja Apache
RUN a2enmod rewrite && \
    a2dissite 000-default.conf && \
    a2ensite laravel.conf

# Praca w katalogu aplikacji
WORKDIR /var/www/html

# UWAGA: zakładamy, że projekt Laravel będzie zamontowany wolumenem — katalogi mogą nie istnieć podczas budowy
# Dlatego NIE używamy chmod/chown na build-time

EXPOSE 80
