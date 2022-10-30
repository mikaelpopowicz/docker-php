#!/usr/bin/env sh

if [ $# -gt 0 ]; then
    # If we passed a command, run it as root
    exec "$@"
else
    exec "apache2-foreground"
fi
