#!/bin/sh

if [ -e "$(pwd)/composer.json" ]; then
    /usr/local/bin/php /usr/local/bin/composer install -vvv --no-interaction
    if [ -d "$(pwd)/vendor" ]; then
        chgrp -R users "$(pwd)"/vendor
    fi
fi

if [ ! -z $@ ]; then
    if [ ! -z "$(which $1)" ]; then
        exec "$@"
    else
    	/usr/local/bin/php "$@"
    fi
elif [ -d "$(pwd)/public" ]; then
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi