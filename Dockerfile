FROM php:8.2.0-apache
RUN a2enmod rewrite 
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update \
    && apt-get install -y libzip-dev \
    && apt-get install -y zlib1g-dev \    
    && apt-get install -y libpng-dev libfreetype6-dev libjpeg62-turbo-dev libgd-dev libwebp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip \
    #&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-webp-dir=/usr/include/\
    && docker-php-ext-install gd
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring
RUN docker-php-ext-enable intl mbstring


COPY . /var/www/html
EXPOSE 80
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# RUN export PATH=~/.config/composer/vendor/bin:$PATH

ENV PATH="$PATH:~/.config/composer/vendor/bin"

# RUN source ~/.bash_profile

RUN apt-get update
RUN apt-get -y install nano

#add nodejs

SHELL ["/bin/bash", "--login", "-c"]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN nvm install 22

# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash 
# RUN export NVM_DIR="$HOME/.nvm"
# RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
# RUN [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
# RUN nvm install 22

# RUN apt-get -y install nodejs npm
# RUN npm install

RUN echo 'ServerName 127.0.0.1' >> /etc/apache2/apache2.conf

#install laravel
RUN composer global require laravel/installer
# USER root

RUN chown -R www-data:www-data /var/www
# RUN chmod -R 777 /var/www/html/app/tmp
# RUN chmod -R 777 /var/www/html/app/webroot
# RUN chmod -R 777 /var/www/html/app/webroot/files

# USER nobody