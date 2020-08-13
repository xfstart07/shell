#!/usr/bin/env bash
set -eu

# 9  测试当前的用户是否是teacher，若不是则提示“Not teacher”

if [ `echo $USER` != "teacher" ]; then echo "Not teacher"; fi  

# Not teacher 