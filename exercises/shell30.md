# 30道shell练习题

1 先测试“/etc/vsftpd”、“/etc/hosts”是否为目录，并通过“$?”变量查看返回状态值，据此判断测试结果。

```bash
[root@C6 ~]#  [ -d /etc/vsftpd ]
[root@C6 ~]# echo $?
1
[root@C6 ~]#  [ -d /etc/hosts ]
[root@C6 ~]# echo $?
1
```

2 测试“/media/cdrom/Server”及其父目录是否存在，如果存在则显示“YES”，否则不输出任何信息。

```bash
[root@C6 ~]# if [ -d /media/cdrom ] && [ -f /media/cdrom/Server]; then echo "yes" ; fi
```



3 使用普通用户teacher登录，并测试是否对“/etc/passwd”文件有读、写权限，如果是则显示“YES”。

```bash
[teacher@C6 ~]$ [ -r /etc/passwd ] && echo "yes"
yes
[teacher@C6 ~]$ [ -w /etc/passwd ] && echo "yes"
```



4 测试当前登录到系统中的用户数量是否小于或等于10，是则输出“YES”。

```bash
[root@C6 ~]# [ `who | wc -l` -le 10 ] && echo "yes"
yes
```



5 提取出“/boot”分区的磁盘使用率，并判断是否超过95%（为了便于理解，操作步骤以适当进行分解）

```bash
[root@C6 ~]# [ `df | grep '/boot'| awk '{print $5}' | awk -F'%' '{print $1}'`  -ge 95 ] && echo "Warning"
```



6 提示用户输入一个文件路径，并判断是否是“/etc/inittab”,如果是 输出“yes”



```bash
[root@C6 ~]# read -p "Localtion:" FIlePath
Localtion:/etc/inittab
[root@C6 ~]# [ $FIlePath = '/etc/inittab' ] && echo "yes"
yes
```



7 若当前环境变量LANG的内容不是“en.US”,则输出LANG变量的值，否则无输出。

```bash
[root@C6 ~]# if [ `echo $LANG` != "en.us" ] ;then echo $LANG ;fi
en_US.UTF-8
```

8 使用touch命令建立一个新文件，测试其内容是否为空，向文件中写入内容后，再次进行测试

```bash
[root@C6 ~]# touch 1.txt
[root@C6 ~]# [ -z 1.txt ] && echo "yes"
[root@C6 ~]# [ -z `cat 1.txt` ] && echo "yes"
yes
[root@C6 ~]# echo 123 > 1.txt
[root@C6 ~]# [ -z `cat 1.txt` ] && echo "yes"
```



9 测试当前的用户是否是teacher，若不是则提示“Not teacher”

```bash
[root@C6 ~]# if [ `echo $USER` != "teacher" ] ;then  echo "Not teacher";fiNot teacher
```



10 只要“/etc/rc.d/rc.local”或者“/etc/init.d/rc.local”中有一个是文件，则显示“YES”，否则无任何输出。

```bash
[root@C6 ~]# [ -f /etc/rc.d/rc.local ] || [ -f /etc/init.d/rc.local ] && echo "yes"
yes
```



11 测试“/etc/profile” 文件是否有可执行权限，若确实没有可执行权限，则提示“No x mode.”的信息。

```bash
[root@C6 ~]# [ ! -x  /etc/profile ] && echo "No x mode"
No x mode
```

12 若当前的用户是root且使用的shell程序是“/bin/bash”, 则显示“YES”，否则无任何输出。

```bash
[root@C6 ~]# [ `echo $USER` == "root" ] && [ `echo $SHELL` == "/bin/bash" ] && echo "yes"
yes
```



13 检查“/var/log/messages”文件是否存在，若存在则统计文件内容的行数并输出，否则不做任何操作（合理使用变量，可以提高编写效率）。

```bash
[root@C6 ~]# [ -f /var/log/messages ] && echo `wc -l /var/log/messages`
6 /var/log/messages
```



14 提示用户指定备份目录的路径，若目录已存在则显示提示信息后跳过，否则显示相应提示信息后创建该目录。

```bash
#!/bin/bash
read -p "Please import a backup dirname: " BakDir
if [ ! -d $BakDir ] 
then 
    mkdir $BakDir
fi
```

16 检查portmap进程是否已经存在，若已经存在则输出“portmap service if running.” ;否则检查是否存在“/etc/rc.d/init.d/portmap” 可执行脚本，存在则启动portmap服务，否则提示“no portmap script file.”。

```bash
#!/bin/bash
Process=`ps aux | grep portmap | grep -v grep`
if [ -n $Process ] ; then
if [ ! -f /etc/rc.d/init.d/portmap ] ; then
echo "no portmap scipt file"
fi
else
echo "portmap sercice is running"
fi
```

17 每隔五分钟监测一次mysqld服务进程的运行状态，若发现mysqld进程已终止，则在“/var/log/messages”文件中追加写入日志信息（包括当时时间），并重启mysqld服务；否则不进行任何操作

```bash
#!/bin/bash
Process=`ps -ef | grep "mysqld_safe" | grep -v "grep" | wc -l`
if [  $Process != 0 ] ; then
echo "Mysql Process is running"  >> /dev/null
else
echo "`date +"%Y-%m-%d %H:%M:%S"` ERROR: Mysql Process is Not running" >> /var/log/messages
/etc/init.d/mysqld start >> /dev/null
fi

*/5 * * * * /bin/bash /root/1.sh
```

18 依次输出三条文字信息，包括一天中的“Moring”、“Noon”、“Evening”字串。

```bash
#!/bin/bash
for TM in "Morning" "Noon" "Evening"
do
    echo "The $TM of the day. "
done
```

19 对于使用“/bin/bash”作为登录shell的系统用户，检查他们在“/opt”目录中拥有的子目录或文件数量，如果超过100个，则列出具体数值及对应的用户账号

```bash
#!/bin/bash
User=`grep "/bin/bash" /etc/passwd | awk -F ':' '{print $1}'`
Number=`find /opt -user $User | grep -v ^/opt$  | wc -l`
if [  $Number -gt 100 ] ; then
echo $User:$Number
fi
```

20 计算“/etc”目录中所有“*.conf”形式的配置文件所占用的总空间大小

```bash
#!/bin/bash
FileSize=$(ls -l $(find /etc -type f -name  *.conf ) | awk '{print $5}')
total=0
for i in $FileSize
do
total=$(expr $total + $i)
done
echo "total size of conf file is $total"
```



21 由用户从键盘输入一个大于1的整数（如50），并计算从1到该数之间各整数的和

```bash
#!/bin/bash
sum=0
read -p "Please inport a >1 sumber : " Number
for i in $Number
do
sum=$[$Number + $i]
done
echo "Sum is $sum"
```



22 批量添加20个系统用户账号，用户名称依次为“stu1”、“stu2”、“stu3”、……“stu20”，各用户的初始密码均设置为“123456”

23 编写一个批量删除用户的脚本程序，将上例中添加的20个用户删除。

```bash
#!/bin/bash
if [ $1 == "add" ] ;then
for i in `seq 1 20`
do
useradd stu$i >> /dev/null
echo 123 | passwd --stdin stu$i
echo "stu$i is create"
done
elif [ $1 == "del" ] ;then
if [  -n `grep stu /etc/passwd` ] ;then
echo "stu user is not create,please inport options add"
exit 1
else
for i in `seq 1 20`
do
userdel -r stu$i
echo "stu$i is remove"
done
fi
else
echo "Please inport options add or del"
fi
```



24 由用户从键盘输入一个字符，并判断该字符是否为字母、数字或者其他字符，并输出相应的提示信息。

```bash
#!/bin/bash
read -p "Please input a character: " Cha
m=`echo $Cha | sed s/[a-zA-Z]//g`
n=`echo $Cha | sed s/[0-9]//g`
s=`echo $Cha | sed s/[a-zA-Z0-9]//g`
if [ -z $m  ] ; then
echo "字母"
elif [ -z $n ] ; then
echo "数字"
elif [ -z $s ] ; then
echo "数字字母"
else
echo "your input is 特殊字符"
fi
```



25 编写一个shell程序，计算多个整数值的和，需要计算的各个数值由用户在执行脚本时作为命令行参数给出

```bash
[root@C6 ~]# cat 1.sh
#!/bin/bash
echo $[$1+$2+3]
```



26 循环提示用户输入字符串，并将每次输入的内容保存到临时文件“/tmp/input.txt”中，当用户输入“END”字符串时退出循环体，并统计出input.txt文件中的行数、单词数、字节数等信息，统计完后删除临时文件

```bash
#!/bin/bash
while true
do
read -p "Please input a string: " Str
echo $Str >> /tmp/test.txt
if [ $Str == "end" ];then
break
fi
done
wc /tmp/test.txt && rm -rf /tmp/test.txt
```

27 删除系统中的stu1~stu20各用户账号，但stu8、stu18除外

```bash
#!/bin/bash
for i in `seq 1 20`
do
if [ $i -eq 8 ] || [ $i -eq 18 ] ; then
continue
fi
userdel -r stu$i >> /dev/nul
echo "stu$i is remove"
done
```



28 在脚本中定义一个help函数，当用户输入的脚本参数不是“start”或“stop”时，加载该函数并给出关于命令用法的帮助信息，否则给出对应的提示信息

```bash
#!/bin/bash
help() {
echo "Usage: "$0" start|stop"
}
case "$1" in
start)
echo "starting..."
;;
stop)
echo "stoping..."
;;
*)
help
esac
```



29 在脚本中定义一个加法函数，用于计算两个数的和，并调用该函数分别计算12+34、56+789的和

```bash
#!/bin/bash
sum() {
echo `expr $1 + $2`
}
sum 12 34
sum 56 789
```



30 从1加到100

```bash
#!/bin/bash
for i in `seq 1 100`
do
   sum=$[$sum+$i]
   echo $i
done
   echo $sum
```