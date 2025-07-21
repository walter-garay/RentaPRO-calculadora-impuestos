FROM php:8.2-cli

# Install system dependencies and Node.js LTS
RUN apt-get update && \
    apt-get install -y git curl zip unzip libpng-dev libonig-dev libxml2-dev libpq-dev && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions (including PostgreSQL)
RUN docker-php-ext-install mbstring exif pcntl bcmath gd pdo pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files and install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy package.json and install Node dependencies
COPY package*.json ./
RUN npm ci

# Copy application files
COPY . .

# Set proper permissions and create necessary directories
RUN mkdir -p /var/www/html/storage/logs \
    && mkdir -p /var/www/html/storage/framework/cache/data \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/app/public \
    && mkdir -p /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Build assets and clean up
RUN npm run build && npm prune --production

# Laravel setup - clear & cache configs
RUN php artisan config:clear || true \
    && php artisan route:clear || true \
    && php artisan view:clear || true \
    && php artisan cache:clear || true
    # && php artisan config:cache || true \
    # && php artisan route:cache || true \
    # && php artisan view:cache || true

# Run migrations on container startup
CMD php artisan config:clear && php artisan migrate --force && php -S 0.0.0.0:8080 -t public/
