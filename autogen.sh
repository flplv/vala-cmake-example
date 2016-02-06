#!/bin/sh

if [ -e $(dirname "$0")/.gitmodules ]; then
    (cd "$(dirname "$0")" && git submodule update --init --recursive)
fi

$(dirname $0)/configure "$@"
