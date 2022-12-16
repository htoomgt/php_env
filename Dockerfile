FROM php:7.3-fpm-alpine

RUN apk update && apk add tzdata
ENV TZ="Asia/Yangon"

RUN apk add --no-cache libpng libpng-dev && \ 
        docker-php-ext-install pdo pdo_mysql sockets gd  \
        && apk del libpng-dev

RUN docker-php-ext-install mbstring 

RUN apk add libzip-dev  && \
        docker-php-ext-install zip 

RUN apk add libxml2-dev  \
    && docker-php-ext-install xml  

RUN curl -sS https://getcomposer.org/installer​ | php -- \
     --install-dir=/usr/local/bin --filename=composer

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN apk add mysql-client

RUN apk add busybox-extras

WORKDIR /topup-app/

COPY . .

RUN sed -i 's/\[client-server\]/[client-server] \n protocol=tcp/g' /etc/my.cnf
