#!/bin/sh


if [ ! -z $@ ];then
    exec "$@"
elif [ -d "$(pwd)/public" ]; then
    /usr/local/apache2/bin/httpd -DFOREGROUND
fi