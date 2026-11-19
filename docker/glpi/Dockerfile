FROM php:8.5.13-apache-trixie@sha256:0110f2cd5f4d58417afc7340b22c4ddcce54e970b87c03a6c77259b07b47c325

LABEL org.opencontainers.image.title="GLPI AWS Modernization"
LABEL org.opencontainers.image.description="Unofficial GLPI container for automated cloud deployments"
LABEL org.opencontainers.image.source="https://github.com/omar3bs/glpi-aws-devops-modernization"

ARG GLPI_VERSION=12.0.2

ENV TZ=UTC

WORKDIR /var/www/glpi

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libzip-dev \
    libbz2-dev \
    libldap-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap --with-libdir=lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH) \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        gd \
        intl \
        zip \
        bcmath \
        bz2 \
        exif \
        ldap \
    && rm -rf /var/lib/apt/lists/*

# Download and verify the official GLPI release
ARG GLPI_SHA256=028d9d275cf747600bbbefe072fd0724c1d4e7eee18378e696fea60a73d50359

RUN curl -fsSL --retry 3 \
    "https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz" \
    -o /tmp/glpi.tgz \
    && echo "${GLPI_SHA256}  /tmp/glpi.tgz" | sha256sum -c - \
    && tar -xzf /tmp/glpi.tgz \
        --strip-components=1 \
        -C /var/www/glpi \
    && rm /tmp/glpi.tgz

# Configure application ownership and permissions
RUN chown -R root:root /var/www/glpi \
    && chown -R www-data:www-data \
        /var/www/glpi/config \
        /var/www/glpi/files \
        /var/www/glpi/plugins \
        /var/www/glpi/marketplace

# Configure Apache for GLPI
COPY apache/glpi.conf /etc/apache2/sites-available/glpi.conf

RUN a2enmod rewrite \
    && a2dissite 000-default.conf \
    && a2ensite glpi.conf

# Configure PHP for GLPI
COPY php/glpi.ini /usr/local/etc/php/conf.d/99-glpi.ini

# Configure Apache for non-root execution
RUN sed -i 's/Listen 80$/Listen 8080/' /etc/apache2/ports.conf \
    && mkdir -p /var/run/apache2 /var/lock/apache2 \
    && chown -R www-data:www-data \
        /var/run/apache2 \
        /var/lock/apache2 \
        /var/log/apache2

# HEALTHCHECKS
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -fsS http://localhost:8080/ || exit 1

# SCRIPT FOR AUTO INITIALISING
COPY --chmod=755 entrypoint.sh /usr/local/bin/glpi-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/glpi-entrypoint.sh"]
CMD ["apache2-foreground"]

# Run as a non-privileged user
USER www-data

EXPOSE 8080
