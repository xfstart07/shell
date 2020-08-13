#!/usr/bin/env bash
set -eu

# 20  计算“/etc”目录中所有“*.conf”形式的配置文件所占用的总空间大小

FileSize=$(ls -l $(find /etc -type f -name  *.conf ) | awk '{print $5}')
total=0
for i in $FileSize; do
    total=$(expr $total + $i)
done
echo "total size of conf file is $total"

# total size of conf file is 6911