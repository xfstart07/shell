#!/usr/bin/env bash
set -eu

[ `echo $USER` == "root" ] && [ `echo $SHELL` == "/bin/bash" ] && echo "yes"