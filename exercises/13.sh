#!/usr/bin/env bash
set -eu

# 13  检查“/var/log/messages”文件是否存在，若存在则统计文件内容的行数并输出，否则不做任何操作（合理使用变量，可以提高编写效率）

# macos 没有 messages 文件，所以使用 system.log
[ -f /var/log/system.log ] && echo `wc -l /var/log/system.log`

# 3593 /var/log/system.log
