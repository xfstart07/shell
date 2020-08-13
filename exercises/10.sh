#!/usr/bin/env bash
set -eu

# 10  只要“/etc/rc.d/rc.local”或者“/etc/init.d/rc.local”中有一个是文件，则显示“YES”，否则无任何输出。

# macos 系统并没有这两个文件，所以不会输出yes
[ -f /etc/rc.d/rc.local ] || [ -f /etc/init.d/rc.local ] && echo "yes"