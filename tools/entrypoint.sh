#!/bin/sh

if [ -f /usr/local/etc/php/conf.d/xdebug.ini ]; then
   sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$(ip route | awk 'NR==1 {print $3}')/g" /usr/local/etc/php/conf.d/xdebug.ini
fi

if [ -e "$(pwd)/composer.json" ]; then
    /usr/local/bin/php /usr/local/bin/composer install --no-interaction $(if ! [[ "$DEBUG" = "true" ]] ; then echo '--no-dev'; fi)
fi

if [ -d "$(pwd)/vendor/bin" ]; then
    export PATH=$PATH:$(pwd)/vendor/bin
fi

if [[ ! -z "$1" ]]; then
    if [[ -z "$(which -- $1)" ]]; then
        /usr/local/bin/php "$@"
    else
        exec "$@" 
    fi 
elif [ -d "$(pwd)/public" ]; then
    # Apache gets grumpy about PID files pre-existing
    rm -f /usr/local/apache2/logs/httpd.pid
    set -e

    echo -e "\n==============================================================\n==============================================================\n======================== OPEN IN YOUR ========================\n==============================================================\n==============================================================\n" 
 
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi

chgrp -R users $(pwd)