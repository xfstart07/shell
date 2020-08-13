#!/usr/bin/env bash
set -eu

# 1. 先测试“/etc/vsftpd”、“/etc/hosts”是否为目录，并通过“$?”变量查看返回状态值，据此判断测试结果。

[ -d /etc/vsftpd ]
echo $?
# 1

[ -d /etc/hosts ]
echo $?
# 1

#> [ -d ] 判断是否为文件目录
