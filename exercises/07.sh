#!/usr/bin/env bash
set -eu

# 7  若当前环境变量LANG的内容不是“en.US”,则输出LANG变量的值，否则无输出。

if [ `echo $LANG` != "en.US" ]; then echo "$LANG"; fi

# zh_CN.UTF-8