#!/bin/sh

COMPOSER_VERISON=1.6.4

curl -L https://api.github.com/repos/gerardo-junior/TAP.api/tarball/master | tar xz --strip-components=1 --directory=$(pwd)

if [ -e "$(pwd)/composer.lock" ]; then
   curl -Ls https://github.com/composer/composer/releases/download/${COMPOSER_VERISON}/composer.phar | php install -vvv --no-interaction --prefer-source
fi

if [ -d "$(pwd)/public" ]; then
    php -S localhost:80 -t $(pwd)/public
fi

if [ ! -z $@ ];then
    exec "$@"
fi