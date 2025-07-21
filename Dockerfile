FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first for better caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy package.json files for better caching
COPY package*.json ./

# Install Node.js dependencies (including dev dependencies for build)
RUN npm ci

# Copy the rest of the application
COPY . .

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Build assets
RUN npm run build

# Generate application key if .env exists
RUN if [ -f .env ]; then php artisan key:generate --force; fi

# Cache Laravel configuration
RUN php artisan config:cache || true
RUN php artisan route:cache || true
RUN php artisan view:cache || true

# Create storage link
RUN php artisan storage:link || true

# Expose port
EXPOSE $PORT

# Start the application
CMD php artisan serve --host=0.0.0.0 --port=$PORT
