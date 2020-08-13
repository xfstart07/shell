#!/usr/bin/env bash
set -eu

# 3. 使用普通用户teacher登录，并测试是否对“/etc/passwd”文件有读、写权限，如果是则显示“YES”。

[ -r /etc/passwd ] && echo "yes read"
# [teacher@C6 ~]$ [ -r /etc/passwd ] && echo "yes"
# 这里我是在本地执行的，用户是 x

# yes

[ -w /etc/passwd ] && echo "yes write"

#> -r 判断用户对文件是否有读权限
#> -w 判断用户对文件是否有写权限
