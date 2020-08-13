#!/usr/bin/env bash
set -eu

# 5  提取出“/boot”分区的磁盘使用率，并判断是否超过95%（为了便于理解，操作步骤以适当进行分解）

# 在 macos 下运行，所以使用 /dev/disk1s1
[ `df | grep '/dev/disk1s1'| awk '{print $5}' | awk -F'%' '{print $1}'` -ge 95 ] && echo "Warning"

# 测试时硬盘使用率很小，所以不会输出任何结果

[ `df | grep 'devfs'| awk '{print $5}' | awk -F'%' '{print $1}'` -ge 95 ] && echo "Warning"

# Warning

# 分步骤

df | grep 'devfs'

df | grep 'devfs'| awk '{print $5}'

df | grep 'devfs'| awk '{print $5}' | awk -F'%' '{print $1}'

# 难点：awk 的使用