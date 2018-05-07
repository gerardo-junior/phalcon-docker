#!/bin/sh

if [ -e "$(pwd)/composer.json" ]; then
   /usr/local/bin/php /usr/local/bin/composer install -vvv --no-interaction
    if [ -d "$(pwd)/vendor" ]; then
        chgrp -R users $(pwd)/vendor
    fi
fi

if [ -d "$(pwd)/vendor/bin" ]; then
    export PATH=$PATH:$(pwd)/vendor/bin
fi

if [ ! -z $@ ]; then
    if [ -z "$(which $1)" ]; then 
        /usr/local/bin/php "$@" 
    else 
        exec "$@" 
    fi
elif [ -d "$(pwd)/public" ]; then
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi