# Use the official PHP 8.2 image as a base image
FROM php:8.2-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Set working directory
WORKDIR /var/www/html

# Copy the Symfony project files into the container
COPY . .

# Install project dependencies
RUN composer install --no-interaction --prefer-dist

# Expose the port that the app will be running on
EXPOSE 8080

# Run the Symfony server or PHP's built-in server
CMD ["php", "bin/console", "server:start", "--no-tls", "--port=8080"]
