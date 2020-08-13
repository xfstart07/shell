#!/usr/bin/env bash
set -eu

# 6  提示用户输入一个文件路径，并判断是否是“/etc/inittab”,如果是 输出“yes”

read -p "Location: " FilePath
[ $FilePath = '/etc/inittab' ] && echo "yes"

# Location: /etc/inittab
# yes