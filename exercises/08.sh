#!/usr/bin/env bash
set -eu

# 8  使用touch命令建立一个新文件，测试其内容是否为空，向文件中写入内容后，再次进行测试

touch 1.txt

[ -z 1.txt ] && echo "yes0"
[ -z `cat 1.txt` ] && echo "yes1"

echo 123 >1.txt
[ -z `cat 1.txt` ] && echo "yes2"

# yes1