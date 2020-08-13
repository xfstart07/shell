#!/usr/bin/env bash
set -eu

# 21  由用户从键盘输入一个大于1的整数（如50），并计算从1到该数之间各整数的和

sum=0
read -p "请输入大于1的数字: " Number

for i in $(seq 0 $Number); do 
    sum=$[$sum + $i]
done 

echo "Sum is $sum"

#  100 => 5050

# seq 表示连续