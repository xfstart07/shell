#!/usr/bin/env bash
set -eu

# 28  在脚本中定义一个help函数，当用户输入的脚本参数不是“start”或“stop”时，加载该函数并给出关于命令用法的帮助信息，否则给出对应的提示信息

help() {    
    echo "Usage: $0 start|stop"
    case "$1" in 
        start)
            echo "starting....";;
        stop)
            echo "stoping...";;
    esac 
}

help $1

# 函数中的 $1 以上的变量都需要传递进去