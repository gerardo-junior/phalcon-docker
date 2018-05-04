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
    cd ./cphalcon-${PHALCON_VERSION}/build/ && \
    sh ./install --phpize /usr/local/bin/phpize --php-config /usr/local/bin/php-config && \
    cd ../../ && \
    echo -e "[phalcon] \n" \
            "extension = $(find /usr/local/lib/php/extensions/ -name phalcon.so)" > /usr/local/etc/php/conf.d/phalcon.ini && \
    rm -rf ./cphalcon-${PHALCON_VERSION} && \
    unset PHALCON_VERSION

# Compile and install XDebug
ENV XDEBUG_VERSION 2.6.0
ENV XDEBUG_CONFIG_HOST 0.0.0.0
ENV XDEBUG_CONFIG_PORT 9000
ENV XDEBUG_CONFIG_IDEKEY "IDEA_XDEBUG"
RUN if [ "$DEBUG" = "true" ] ; then set -xe && \
	curl -L https://github.com/xdebug/xdebug/archive/${XDEBUG_VERSION}.tar.gz | tar xz && \
    cd ./xdebug-${XDEBUG_VERSION} && \
    phpize && \
    sh ./configure --enable-xdebug && \
    make clean && \
    make && \
    make install && \
    cd ../ && \
    echo -e "[XDebug] \n" \
            "zend_extension = $(find /usr/local/lib/php/extensions/ -name xdebug.so) \n" \
            "xdebug.remote_enable = on \n" \
            "xdebug.remote_host = ${XDEBUG_CONFIG_HOST} \n" \
            "xdebug.remote_port = ${XDEBUG_CONFIG_PORT} \n" \
            "xdebug.remote_handler = \"dbgp\" \n" \
            "xdebug.remote_connect_back = off \n" \
            "xdebug.cli_color = on \n" \
            "xdebug.idekey = \"${XDEBUG_CONFIG_IDEKEY}\"" > /usr/local/etc/php/conf.d/xdebug.ini && \
    rm -rf ${PWD}/xdebug-${XDEBUG_VERSION} ; fi && \
    unset XDEBUG_VERSION && \
    unset XDEBUG_CONFIG_HOST && \
    unset XDEBUG_CONFIG_PORT && \
    unset XDEBUG_CONFIG_IDEKEY

# System cleanup
RUN unset DEBUG
RUN apk del build-dependencies \
            autoconf \
            g++ \
            file \
            re2c \
            make 


# Copy scripts
COPY ./tools/start.sh /usr/local/bin/start.sh
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/entrypoint.sh

# Create project directory
RUN mkdir -p /usr/share/src
VOLUME ["/usr/share/src"]
WORKDIR /usr/share/src
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]