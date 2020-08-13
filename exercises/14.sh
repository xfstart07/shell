#!/usr/bin/env bash
set -eu

# 14  提示用户指定备份目录的路径，若目录已存在则显示提示信息后跳过，否则显示相应提示信息后创建该目录。

read -p "请输入备份文件夹名称: " Backup 
if [ ! -d $Backup ]; then
    mkdir -p "$Backup"
    echo "没有文件夹 $Backup, 创建成功!"
fi 

# 请输入备份文件夹名称: backup
# 没有文件夹 backup, 创建成功!
