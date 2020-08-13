#!/usr/bin/env bash
set -eu

# 30 从1加到100

sum=0
for i in `seq 1 100`; do 
  sum=$[$sum+$i]
  echo $i 
done 
echo "sum=$sum"
