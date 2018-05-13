#!/bin/sh

if [ -e "$(pwd)/composer.json" ]; then
    su www-data -c "/usr/local/bin/php /usr/local/bin/composer install --no-interaction $(if [[ ! \"$DEBUG\" = \"true\" ]] ; then echo '--no-dev'; fi)"
fi

if [ -d "$(pwd)/vendor/bin" ]; then
    export PATH=$PATH:$(pwd)/vendor/bin
fi

if [[ ! -z "$1" ]]; then
    if [[ -z "$(which -- $1)" ]]; then
        su www-data -c "/usr/local/bin/php /usr/local/bin/composer $@"
    else
        su www-data -c "$@" 
    fi 
elif [ -d "$(pwd)/public" ]; then
    echo -e "\n" \
            "==============================================================\n" \
            "==============================================================\n" \
            "==================== OPEN IN YOUR BROWSER ====================\n" \
            "==============================================================\n" \
            "==============================================================\n" 
 
    # Apache gets grumpy about PID files pre-existing
    rm -f /usr/local/apache2/logs/httpd.pid
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi

chgrp -R users $(pwd)