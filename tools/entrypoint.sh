#!/bin/sh
set -ex

if [ -e "$(pwd)/composer.json" ]; then
    /usr/local/bin/php /usr/local/bin/composer install --no-interaction $(if !$DEBUG; then echo '--no-dev'; else echo '--dev -vvv'; fi)
fi

if [ -d "$(pwd)/vendor/bin" ]; then
    export PATH=$PATH:$(pwd)/vendor/bin
fi

if [ ! -z "$@" ]; then
    exec "$@" 
elif [ -d "$(pwd)/public" ]; then
    # Apache gets grumpy about PID files pre-existing
    rm -f /usr/local/apache2/logs/httpd.pid
    
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi

chgrp -R users $(pwd)