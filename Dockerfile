FROM php:7.4-fpm

# Install system dependencies
# git, zip and unzip are used to install laravel dependencies via composer
RUN apt-get update -y && apt-get install -y \
    libmcrypt-dev \ 
    openssl \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev

# Install php dependencies
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
COPY --from=composer:1.10.17 /usr/bin/composer /usr/local/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www
COPY . .

CMD bash -c "composer install && php artisan key:generate && php artisan migrate && php artisan serve --host 0.0.0.0 --port 8000"