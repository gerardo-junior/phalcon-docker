#!/bin/sh


curl -L https://api.github.com/repos/gerardo-junior/TAP.api/tarball/master | tar xz --strip-components=1 --directory=$(pwd)

if [ -e "$(pwd)/composer.lock" ]; then
    COMPOSER_VERISON=1.6.4
    curl -Ls https://github.com/composer/composer/releases/download/${COMPOSER_VERISON}/composer.phar | php -- install -vvv --no-interaction --prefer-source
    if [ -d "$(pwd)/vendor" ]; then
        chgrp -R users "$(pwd)"/vendor
    fi
fi

if [ ! -z $@ ];then
    exec "$@"
else [ -d "$(pwd)/public" ]; then
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi