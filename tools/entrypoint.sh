#!/bin/sh


if [ ! -z $@ ];then
    exec "$@"
else 
    if [ -d "$(pwd)/public" ]; then
        /usr/local/apache2/bin/httpd -DFOREGROUND
    fi
fi