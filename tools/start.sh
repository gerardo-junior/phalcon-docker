#!/bin/sh

echo 'Downloading api source code ...'
curl -L https://api.github.com/repos/gerardo-junior/TAP.api/tarball/$(if [ -z "$BRANCH" ] ; then echo 'master'; else echo "$BRANCH"; fi) | tar xz --strip-components=1 --directory=$(pwd)

exec /usr/local/bin/entrypoint.sh "$@"