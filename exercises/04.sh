#!/usr/bin/env bash
set -eu

# 4  测试当前登录到系统中的用户数量是否小于或等于10，是则输出“YES”。

[ `who |wc -l` -le 10 ] && echo "yes"

# test
