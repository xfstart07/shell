#!/usr/bin/env bash
set -eu

sum() {
    echo `expr $1 + $2`
}

sum $1 $2