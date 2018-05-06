#!/bin/sh

if [ -e "$(pwd)/composer.json" ]; then
    /usr/local/bin/php /usr/local/bin/composer install -vvv --no-interaction
fi

if [ -d "$(pwd)/vendor/bin" ]; then
    export PATH=$PATH:$(pwd)/vendor/bin
fi

if [ ! -z $@ ]; then
    exec "$@"
elif [ -d "$(pwd)/public" ]; then
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi