#!/bin/sh

if [ -e "$(pwd)/composer.json" ]; then
    /usr/local/bin/php /usr/local/bin/composer -vvv --no-interaction --prefer-source
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