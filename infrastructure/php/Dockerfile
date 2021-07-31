FROM php:8.0-fpm

ARG spacer=' '
ARG GIT_USER_NAME=Symfony
ARG GIT_USER_SURNAME=Dockered-container
ARG GIT_USER_EMAIL=nomail@nomail.com
ARG SYMFONY_APP_NAME=.

ENV GIT_USER_NAME ${GIT_USER_NAME}
ENV GIT_USER_SURNAME ${GIT_USER_SURNAME}
ENV GIT_USER_EMAIL ${GIT_USER_EMAIL}
ENV SYMFONY_APP_NAME ${SYMFONY_APP_NAME}


RUN apt update \
    && apt install -y zlib1g-dev g++ git libicu-dev zip libzip-dev zip \
    && docker-php-ext-install intl opcache pdo pdo_mysql \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

WORKDIR /var/www/symfony_docker

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN echo -e "\n CONFIGURANDO GIT PARA : "
RUN echo ${GIT_USER_NAME}
RUN echo -e '\n'
RUN git config --global user.email ${GIT_USER_EMAIL}  \ 
    && git config --global user.name "${GIT_USER_NAME}$spacer${GIT_USER_SURNAME}"  



RUN symfony check:requirements

RUN symfony new ${SYMFONY_APP_NAME}
