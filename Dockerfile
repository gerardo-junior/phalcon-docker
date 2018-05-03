FROM library/php:7.2-alpine
LABEL maintainer="Gerardo Junior <me@gerardo-junior.com>"

ARG DEBUG=false

RUN apk --update add --virtual build-dependencies \
                               autoconf \
                               g++ \
                               file \
                               re2c \
                               make 

# Compile and install Phalcon
ENV PHALCON_VERSION 3.3.2
RUN set -xe && \
    curl -L https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz | tar xz && \
    cd /cphalcon-${PHALCON_VERSION}/build/ && sh ./install && cd ../../ && \
    echo -e "[phalcon] \n" \
            "extension = $(find /usr/local/lib/php/extensions/ -name phalcon.so)" > /usr/local/etc/php/conf.d/phalcon.ini && \
    rm -rf ./cphalcon-v${PHALCON_VERSION} && \
    unset PHALCON_VERSION

# Compile and install XDebug
ENV XDEBUG_VERSION 2.6.0
ENV XDEBUG_HOST 0.0.0.0
ENV XDEBUG_PORT 9000
ENV XDEBUG_IDEKEY "IDEA_XDEBUG"
RUN if [ "$DEBUG" = "true" ] ; then set -xe && \
	curl -L https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.tar.gz | tar xz && \
    cd ${PWD}/xdebug-${XDEBUG_VERSION} && phpize && ${PWD}/configure --enable-xdebug && make clean && make && make install && cd .. && \
    echo -e "[XDebug] \n" \
            "zend_extension = $(find /usr/local/lib/php/extensions/ -name xdebug.so) \n" \
            "xdebug.remote_enable = 1 \n" \
            "xdebug.remote_host = ${XDEBUG_HOST} \n" \
            "xdebug.remote_port = ${XDEBUG_PORT} \n" \
            "xdebug.remote_handler = \"dbgp\" \n" \
            "xdebug.remote_connect_back = 1 \n" \
            "xdebug.cli_color = 1 \n" \
            "xdebug.idekey = \"${XDEBUG_IDEKEY}\"" > /usr/local/etc/php/conf.d/xdebug.ini && \
    rm -rf ${PWD}/xdebug-${XDEBUG_VERSION} ; else \
    unset XDEBUG_VERSION && \
    unset XDEBUG_HOST && \
    unset XDEBUG_PORT && \
    unset XDEBUG_IDEKEY ; fi

RUN unset DEBUG