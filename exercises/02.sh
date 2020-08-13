#!/usr/bin/env bash
set -eu

# 2. 测试“/media/cdrom/Server”及其父目录是否存在，如果存在则显示“YES”，否则不输出任何信息。

if [ -d /media/cdrom ] && [ -f /media/cdrom/Server ]; then echo "yes"; fi 

# 测试的环境没有文件，什么也出输出

#> -f 判断文件是否存在