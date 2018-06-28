#!/bin/bash
if [ $# -lt 1 ]; then
    echo "Usage: $0 <gdb argument list>"
    echo "where gdb argument list is typically a path to file to debug, optionally followed by core file"
    exit 1
fi
buildroot/output/host/bin/x86_64-linux-gdb -x buildroot/output/staging/usr/share/buildroot/gdbinit "$@"
