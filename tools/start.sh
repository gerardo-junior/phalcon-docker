#!/bin/sh

curl -L https://api.github.com/repos/gerardo-junior/TAP.api/tarball/master | tar xz --strip-components=1 --directory=$(pwd)

exec /usr/local/bin/entrypoint.sh "$@"
