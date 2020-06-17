FROM php:7.3-apache
MAINTAINER Jonas Strassel <jo.strassel@gmail.com>
# Install git ant and java
RUN apt-get update && apt-get -y install gnupg
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get -y install \
    git-core \
    nodejs \
    npm \
    apt-utils \
    zip \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    imagemagick
# Install php-extensions
RUN pecl install mcrypt-1.0.2
RUN docker-php-ext-enable mcrypt

RUN docker-php-ext-configure intl
RUN docker-php-ext-install -j$(nproc) iconv pdo pdo_mysql gd intl
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
# Clone omeka-s - replace with git clone...

RUN rm -rf /var/www/html/*
RUN git clone --branch master https://github.com/omeka/omeka-s.git /var/www/html

# enable the rewrite module of apache
RUN a2enmod rewrite
# Create a default php.ini
COPY files/php.ini /usr/local/etc/php/

# build omeka-s
RUN cd /var/www/html/
# && ant init
#RUN node -v
RUN npm install -g npm@next
RUN cd /var/www/html/ && npm install
RUN cd /var/www/html/ && npm install --global gulp-cli 
RUN cd /var/www/html/ && npm install gulp -g
RUN cat /var/www/html/composer.json
RUN cd /var/www/html/ && gulp init

# Clone all the Omeka-S Modules
RUN cd /var/www/html/modules && curl "https://api.github.com/users/omeka-s-modules/repos?page=$PAGE&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
# Clone all the Omeka-S Themes
RUN cd /var/www/html/themes && rm -r default && curl "https://api.github.com/users/omeka-s-themes/repos?page=$PAGE&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
# copy over the database and the apache config
COPY ./files/database.ini /var/www/html/config/database.ini
COPY ./files/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
# set the file-rights
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R +w /var/www/html/files
# Expose the Port we'll provide Omeka on
EXPOSE 8080


ADD https://github.com/Daniel-KM/Omeka-S-module-IiifServer/releases/download/3.5.15/IiifServer-3.5.15.zip /var/www/html/modules/
RUN cd /var/www/html/modules && unzip IiifServer-3.5.15.zip

ADD https://github.com/ProjectMirador/mirador/releases/download/v2.6.0/build.zip /var/www/html/modules
RUN cd /var/www/html/modules/ && unzip build.zip

# enable the CORS header module of apache
RUN a2enmod headers

COPY ./htaccessmods htaccessmods
RUN cat htaccessmods >> /var/www/html/.htaccess
# COPY ./htaccessmods /var/www/html.htaccess
COPY ./files/local.config.php /var/www/html/config/local.config.php

RUN rm -r /var/www/html/modules/CSVImport
ADD https://github.com/omeka-s-modules/CSVImport/releases/download/v1.1.0/CSVImport-1.1.0.zip /var/www/html/modules
RUN cd /var/www/html/modules && unzip CSVImport-1.1.0.zip

ADD https://github.com/zerocrates/HideProperties/releases/download/v1.0.0/HideProperties-1.0.0.zip /var/www/html/modules
RUN cd /var/www/html/modules && unzip HideProperties-1.0.0.zip

RUN curl http://mirador.britishart.yale.edu/build/mirador/mirador.js >> /var/www/html/modules/build/mirador/mirador.js

ADD https://github.com/digirati-co-uk/omeka-google-analytics-module/archive/v1.0.1.zip /var/www/html/modules
RUN cd /var/www/html/modules && unzip v1.0.1.zip
RUN mv /var/www/html/modules/omeka-google-analytics-module-1.0.1 /var/www/html/modules/GoogleAnalytics

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD https://github.com/SlaveryImages/SimpleCarousel-Custom/archive/v1.0.1.zip /var/www/html/modules
RUN cd /var/www/html/modules && unzip v1.0.1.zip -d SimpleCarousel

ADD https://github.com/vachanda/image-map/releases/download/v2.0.0/ImageMap.zip /var/www/html/modules
RUN cd /var/www/html/modules && unzip ImageMap.zip -d ImageMap
