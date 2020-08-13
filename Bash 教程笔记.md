# Bash 教程笔记

[教程目录](https://github.com/wangdoc/bash-tutorial/blob/master/chapters.yml)

## Bash 的基本语法

### echo 命令

由于后面的例子会大量用到`echo`命令，这里先介绍这个命令。

`echo`命令的作用是在屏幕输出一行文本，可以将该命令的参数原样输出。

```shell
$ echo hello world
hello world
```

#### `-n`参数

默认情况下，`echo`输出的文本末尾会有一个回车符。`-n`参数可以取消末尾的回车符，使得下一个提示符紧跟在输出内容的后面。

```shell
$ echo -n hello world
hello world$
```

#### `-e`参数

`-e`参数会解释引号（双引号和单引号）里面的特殊字符（比如换行符`\n`）。如果不使用`-e`参数，即默认情况下，引号会让特殊字符变成普通字符，`echo`不解释它们，原样输出。

```
$ echo "Hello\nWorld"
Hello\nWorld

# 双引号的情况
$ echo -e "Hello\nWorld"
Hello
World

# 单引号的情况
$ echo -e 'Hello\nWorld'
Hello
World
```

上面代码中，`-e`参数使得`\n`解释为换行符，导致输出内容里面出现换行。

### 命令格式

命令行环境中，主要通过使用 Shell 命令，进行各种操作。Shell 命令基本都是下面的格式。

```shell
$ command [ arg1 ... [ argN ]]
```

上面代码中，`command`是具体的命令或者一个可执行文件，`arg1 ... argN`是传递给命令的参数，它们是可选的。

### 空格

Bash 使用空格（或 Tab 键）区分不同的参数。

```shell
$ command foo bar
```

上面命令中，`foo`和`bar`之间有一个空格，所以 Bash 认为它们是两个参数。

### 分号

分号（`;`）是命令的结束符，使得一行可以放置多个命令，上一个命令执行结束后，再执行第二个命令。

```shell
$ clear; ls
```

上面例子中，Bash 先执行`clear`命令，执行完成后，再执行`ls`命令。

注意，使用分号时，第二个命令总是接着第一个命令执行，不管第一个命令执行成功或失败。

### 命令的组合符`&&`和`||`

除了分号，Bash 还提供两个命令组合符`&&`和`||`，允许更好地控制多个命令之间的继发关系。

```shell
Command1 && Command2
```

上面命令的意思是，如果`Command1`命令运行成功，则继续运行`Command2`命令。

```shell
Command1 || Command2
```

上面命令的意思是，如果`Command1`命令运行失败，则继续运行`Command2`命令。

### type 命令

Bash 本身内置了很多命令，同时也可以执行外部程序。怎么知道一个命令是内置命令，还是外部程序呢？

`type`命令用来判断命令的来源。

```shell
$ type echo
echo is a shell builtin
$ type ls
ls is hashed (/bin/ls)
```

上面代码中，`type`命令告诉我们，`echo`是内部命令，`ls`是外部程序（`/bin/ls`）。

## 引号和转义

Bash 只有一种数据类型，就是字符串。不管用户输入什么数据，Bash 都视为字符串。因此，字符串相关的引号和转义，对 Bash 来说就非常重要。

### 转义

某些字符在 Bash 里面有特殊含义（比如`$`、`&`、`*`）。

```shell
$ echo $date

$
```

上面例子中，输出`$date`不会有任何结果，因为`$`是一个特殊字符。

如果想要原样输出这些特殊字符，就必须在它们前面加上反斜杠，使其变成普通字符。这就叫做“转义”（escape）。

```shell
$ echo \$date
$date
```

上面命令中，只有在特殊字符`$`前面加反斜杠，才能原样输出。

### 单引号

Bash 允许字符串放在单引号或双引号之中，加以引用。

单引号用于保留字符的字面含义，各种特殊字符在单引号里面，都会变为普通字符，比如星号（`*`）、美元符号（`$`）、反斜杠（`\`）等。

### 双引号

双引号比单引号宽松，大部分特殊字符在双引号里面，都会失去特殊含义，变成普通字符。

但是，三个特殊字符除外：美元符号（`$`）、反引号（```）和反斜杠（`\`）。这三个字符在双引号之中，依然有特殊含义，会被 Bash 自动扩展。

```shell
$ echo "$SHELL"
/bin/bash

$ echo "`date`"
Mon Jan 27 13:33:18 CST 2020
```

上面例子中，美元符号（`$`）和反引号（```）在双引号中，都保持特殊含义。美元符号用来引用变量，反引号则是执行子命令。

换行符在双引号之中，会失去特殊含义，Bash 不再将其解释为命令的结束，只是作为普通的换行符。所以可以利用双引号，在命令行输入多行文本。

```shell
$ echo "hello
world"
hello
world
```

双引号还有一个作用，就是保存原始命令的输出格式。

```shell
# 单行输出
$ echo $(cal)
一月 2020 日 一 二 三 四 五 六 1 2 3 ... 31

# 原始格式输出
$ echo "$(cal)"
      一月 2020
日 一 二 三 四 五 六
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30 31
```

## Bash 变量

### 简介

`env`命令或`printenv`命令，可以显示所有环境变量。

```shell
$ env
# 或者
$ printenv
```

下面是一些常见的环境变量。

- `EDITOR`：默认的文本编辑器。
- `HOME`：用户的主目录。
- `HOST`：当前主机的名称。
- `PATH`：由冒号分开的目录列表，当输入可执行程序名后，会搜索这个目录列表。
- `PWD`：当前工作目录。

注意，Bash 变量名区分大小写，`HOME`和`home`是两个不同的变量。

### 创建变量

用户创建变量的时候，变量名必须遵守下面的规则。

- 字母、数字和下划线字符组成。
- 第一个字符必须是一个字母或一个下划线，不能是数字。
- 不允许出现空格和标点符号。

变量声明的语法如下。

```txt
variable=value
```

### 读取变量

读取变量的时候，直接在变量名前加上`$`就可以了。

```
$ foo=bar
$ echo $foo
bar
```

每当 Shell 看到以`$`开头的单词时，就会尝试读取这个变量名对应的值。

### 输出变量，export 命令

用户创建的变量仅可用于当前 Shell，子 Shell 默认读取不到父 Shell 定义的变量。为了把变量传递给子 Shell，需要使用`export`命令。这样输出的变量，对于子 Shell 来说就是环境变量。

`export`命令用来向子 Shell 输出变量。

```shell
export NAME=foo
```

上面命令执行后，当前 Shell 及随后新建的子 Shell，都可以读取变量`$NAME`。

### let 命令

`let`命令声明变量时，可以直接执行算术表达式。

```shell
$ let foo=1+2
$ echo $foo
3
```

上面例子中，`let`命令可以直接计算`1 + 2`。

## Bash 行操作

Bash 内置了 Readline 库，具有这个库提供的很多“行操作”功能，比如命令的自动补全，可以大大加快操作速度。

可以将命令写在`~/.inputrc`文件，这个文件是 Readline 的配置文件。

```shell
set editing-mode vi
```

### 光标移动

Readline 提供快速移动光标的快捷键。

- `Ctrl + a`：移到行首。
- `Ctrl + e`：移到行尾。
- `ESC+b` : 移动到前一个单词的开头
- `ESC+f` : 移动到后一个单词的结尾

### 清除屏幕

`Ctrl + l`快捷键可以清除屏幕，即将当前行移到屏幕的第一行，与`clear`命令作用相同。

### 编辑操作

* `Ctrl + w`：删除光标前面的单词。

### history 命令

如果想搜索某个以前执行的命令，可以配合`grep`命令搜索操作历史。

```shell
$ history | grep /usr/bin
```

## Bash 脚本入门

脚本（script）就是包含一系列命令的一个文本文件。Shell 读取这个文件，依次执行里面的所有命令，就好像这些命令直接输入到命令行一样。所有能够在命令行完成的任务，都能够用脚本完成。

脚本的好处是可以重复使用，也可以指定在特定场合自动调用，比如系统启动或关闭时自动执行脚本。

### Shebang 行

脚本的第一行通常是指定解释器，即这个脚本必须通过什么解释器执行。这一行以`#!`字符开头，这个字符称为 Shebang，所以这一行就叫做 Shebang 行。

`#!`后面就是脚本解释器的位置，Bash 脚本的解释器一般是`/bin/sh`或`/bin/bash`。

```shell
#!/bin/sh
# 或者
#!/bin/bash
```

`#!`与脚本解释器之间有没有空格，都是可以的。

### 执行权限和路径

前面说过，只要指定了 Shebang 行的脚本，可以直接执行。这有一个前提条件，就是脚本需要有执行权限。可以使用下面的命令，赋予脚本执行权限。

```shell
# 给所有用户执行权限
$ chmod +x script.sh
```

### 注释

Bash 脚本中，`#`表示注释，可以放在行首，也可以放在行尾。

```shell
# 本行是注释
echo 'Hello World!'

echo 'Hello World!' # 井号后面的部分也是注释
```

建议在脚本开头，使用注释说明当前脚本的作用，这样有利于日后的维护。

### 脚本参数

调用脚本的时候，脚本文件名后面可以带有参数。

```shell
$ script.sh word1 word2 word3
```

上面例子中，`script.sh`是一个脚本文件，`word1`、`word2`和`word3`是三个参数。

脚本文件内部，可以使用特殊变量，引用这些参数。

- `$0`：脚本文件名，即`script.sh`。
- `$1`~`$9`：对应脚本的第一个参数到第九个参数。
- `$#`：参数的总数。
- `$@`：全部的参数，参数之间使用空格分隔。
- `$*`：全部的参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。

如果脚本的参数多于9个，那么第10个参数可以用`${10}`的形式引用，以此类推。

注意，如果命令是`command -o foo bar`，那么`-o`是`$1`，`foo`是`$2`，`bar`是`$3`。

### exit 命令

`exit`命令后面可以跟参数，该参数就是退出状态。

```shell
# 退出值为0（成功）
$ exit 0

# 退出值为1（失败）
$ exit 1
```

### source 命令

`source`命令用于执行一个脚本，通常用于重新加载一个配置文件。

```shell
$ source .bashrc
```

### 别名，alias 命令

`alias`命令用来为一个命令指定别名，这样更便于记忆。下面是`alias`的格式。

```shell
alias NAME=DEFINITION
```

上面命令中，`NAME`是别名的名称，`DEFINITION`是别名对应的原始命令。注意，等号两侧不能有空格，否则会报错。

一个常见的例子是为`grep`命令起一个`search`的别名。

```shell
alias search=grep
```

## 条件判断

本章介绍 Bash 脚本的条件判断语法。

### if 结构

`if`是最常用的条件判断结构，只有符合给定条件时，才会执行指定的命令。它的语法如下。

```shell
if commands; then
  commands
elif commands; then
  commands...
else
  commands
fi
```

这个命令分成三个部分：`if`、`elif`和`else`。其中，后两个部分是可选的。

> `if`和`then`写在同一行时，需要分号分隔。分号是 Bash 的命令分隔符。它们也可以写成两行，这时不需要分号。

### test 命令

`if`结构的判断条件，一般使用`test`命令，有三种形式。

```shell
# 写法一
test expression

# 写法二
[ expression ]

# 写法三
[[ expression ]]
```

上面三种形式是等价的，但是第三种形式还支持正则判断，前两种不支持。

上面的`expression`是一个表达式。这个表达式为真，`test`命令执行成功（返回值为`0`）；表达式为伪，`test`命令执行失败（返回值为`1`）。注意，第二种和第三种写法，`[`和`]`与内部的表达式之间必须有空格。

```shell
$ test -f /etc/hosts
$ echo $?
0

$ [ -f /etc/hosts ]
$  echo $?
0
```

上面的例子中，`test`命令采用两种写法，判断`/etc/hosts`文件是否存在，这两种写法是等价的。命令执行后，返回值为`0`，表示该文件确实存在。

实际上，`[`这个字符是`test`命令的一种简写形式，可以看作是一个独立的命令，这解释了为什么它后面必须有空格。

下面把`test`命令的三种形式，用在`if`结构中，判断一个文件是否存在。

```shell
# 写法一
if test -e /tmp/foo.txt ; then
  echo "Found foo.txt"
fi

# 写法二
if [ -e /tmp/foo.txt ] ; then
  echo "Found foo.txt"
fi

# 写法三
if [[ -e /tmp/foo.txt ]] ; then
  echo "Found foo.txt"
fi
```

### 判断表达式

`if`关键字后面，跟的是一个命令。这个命令可以是`test`命令，也可以是其他命令。命令的返回值为`0`表示判断成立，否则表示不成立。因为这些命令主要是为了得到返回值，所以可以视为表达式。

常用的判断表达式有下面这些。

### 文件判断

以下表达式用来判断文件状态。

- `[ -a file ]`：如果 file 存在，则为`true`。
- `[ -b file ]`：如果 file 存在并且是一个块（设备）文件，则为`true`。
- `[ -c file ]`：如果 file 存在并且是一个字符（设备）文件，则为`true`。
- `[ -d file ]`：如果 file 存在并且是一个目录，则为`true`。
- `[ -e file ]`：如果 file 存在，则为`true`。
- `[ -f file ]`：如果 file 存在并且是一个普通文件，则为`true`。

[更多]([https://github.com/wangdoc/bash-tutorial/blob/master/docs/condition.md#%E6%96%87%E4%BB%B6%E5%88%A4%E6%96%AD](https://github.com/wangdoc/bash-tutorial/blob/master/docs/condition.md#文件判断))

下面是一个示例。

```shell
#!/bin/bash

FILE=~/.bashrc

if [ -e "$FILE" ]; then
  if [ -f "$FILE" ]; then
    echo "$FILE is a regular file."
  fi
  if [ -d "$FILE" ]; then
    echo "$FILE is a directory."
  fi
  if [ -r "$FILE" ]; then
    echo "$FILE is readable."
  fi
  if [ -w "$FILE" ]; then
    echo "$FILE is writable."
  fi
  if [ -x "$FILE" ]; then
    echo "$FILE is executable/searchable."
  fi
else
  echo "$FILE does not exist"
  exit 1
fi
```

上面代码中，`$FILE`要放在双引号之中。这样可以防止`$FILE`为空，因为这时`[ -e ]`会判断为真。而放在双引号之中，返回的就总是一个空字符串，`[ -e "" ]`会判断为伪。

### 字符串判断

以下表达式用来判断字符串。

- `[ string ]`：如果`string`不为空（长度大于0），则判断为真。
- `[ -n string ]`：如果字符串`string`的长度大于零，则判断为真。
- `[ -z string ]`：如果字符串`string`的长度为零，则判断为真。
- `[ string1 = string2 ]`：如果`string1`和`string2`相同，则判断为真。
- `[ string1 == string2 ]` 等同于`[ string1 = string2 ]`。
- `[ string1 != string2 ]`：如果`string1`和`string2`不相同，则判断为真。
- `[ string1 '>' string2 ]`：如果按照字典顺序`string1`排列在`string2`之后，则判断为真。
- `[ string1 '<' string2 ]`：如果按照字典顺序`string1`排列在`string2`之前，则判断为真。

注意，`test`命令内部的`>`和`<`，必须用引号引起来（或者是用反斜杠转义）。否则，它们会被 shell 解释为重定向操作符。

下面是一个示例。

```shell
#!/bin/bash

ANSWER=maybe

if [ -z "$ANSWER" ]; then
  echo "There is no answer." >&2
  exit 1
fi
if [ "$ANSWER" = "yes" ]; then
  echo "The answer is YES."
elif [ "$ANSWER" = "no" ]; then
  echo "The answer is NO."
elif [ "$ANSWER" = "maybe" ]; then
  echo "The answer is MAYBE."
else
  echo "The answer is UNKNOWN."
fi
```

### 整数判断

下面的表达式用于判断整数。

- `[ integer1 -eq integer2 ]`：如果`integer1`等于`integer2`，则为`true`。
- `[ integer1 -ne integer2 ]`：如果`integer1`不等于`integer2`，则为`true`。
- `[ integer1 -le integer2 ]`：如果`integer1`小于或等于`integer2`，则为`true`。
- `[ integer1 -lt integer2 ]`：如果`integer1`小于`integer2`，则为`true`。
- `[ integer1 -ge integer2 ]`：如果`integer1`大于或等于`integer2`，则为`true`。
- `[ integer1 -gt integer2 ]`：如果`integer1`大于`integer2`，则为`true`。

下面是一个用法的例子。

```shell
#!/bin/bash

INT=-5

if [ -z "$INT" ]; then
  echo "INT is empty." >&2
  exit 1
fi
if [ $INT -eq 0 ]; then
  echo "INT is zero."
else
  if [ $INT -lt 0 ]; then
    echo "INT is negative."
  else
    echo "INT is positive."
  fi
  if [ $((INT % 2)) -eq 0 ]; then
    echo "INT is even."
  else
    echo "INT is odd."
  fi
fi
```

### 正则判断

`[[ expression ]]`这种判断形式，支持正则表达式。

```
[[ string1 =~ regex ]]
```

上面的语法中，`regex`是一个正则表示式，`=~`是正则比较运算符。

下面是一个例子。

```shell
#!/bin/bash

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
  echo "INT is an integer."
  exit 0
else
  echo "INT is not an integer." >&2
  exit 1
fi
```

### 算术判断

Bash 还提供了`((...))`作为算术条件，进行算术运算的判断。

```shell
if ((3 > 2)); then
  echo "true"
fi
```

上面代码执行后，会打印出`true`。

注意，算术判断不需要使用`test`命令，而是直接使用`((...))`结构。这个结构的返回值，决定了判断的真伪。

### 普通命令的逻辑运算

如果`if`结构使用的不是`test`命令，而是普通命令，比如上一节的`((...))`算术运算，或者`test`命令与普通命令混用，那么可以使用 Bash 的命令控制操作符`&&`（AND）和`||`（OR），进行多个命令的逻辑运算。

```shell
$ command1 && command2
$ command1 || command2
```

### case 结构

`case`结构用于多值判断，可以为每个值指定对应的命令，跟包含多个`elif`的`if`结构等价，但是语义更好。它的语法如下。

```shell
case expression in
  pattern )
    commands ;;
  pattern )
    commands ;;
  ...
esac
```

上面代码中，`expression`是一个表达式，`pattern`是表达式的值或者一个模式，可以有多条，用来匹配多个值，每条以两个分号（`;`）结尾。

下面是另一个例子。

```shell
#!/bin/bash

OS=$(uname -s)

case "$OS" in
  FreeBSD) echo "This is FreeBSD" ;;
  Darwin) echo "This is Mac OSX" ;;
  AIX) echo "This is AIX" ;;
  Minix) echo "This is Minix" ;;
  Linux) echo "This is Linux" ;;
  *) echo "Failed to identify this OS" ;;
esac
```

## 循环

Bash 提供三种循环语法`for`、`while`和`until`。

### while 循环

`while`循环有一个判断条件，只要符合条件，就不断循环执行指定的语句。

```shell
while condition; do
  commands
done
```

### until 循环

`until`循环与`while`循环恰好相反，只要不符合判断条件（判断条件失败），就不断循环执行指定的语句。一旦符合判断条件，就退出循环。

```
until condition; do
  commands
done
```

### for...in 循环

`for...in`循环用于遍历列表的每一项。

```shell
for variable in list; do
  commands
done
```

下面是一个例子。

```shell
#!/bin/bash

for i in word1 word2 word3; do
  echo $i
done
```

上面例子中，`word1 word2 word3`是一个包含三个单词的列表，变量`i`依次等于`word1`、`word2`、`word3`，命令`echo $i`则会相应地执行三次。

列表可以由通配符产生。

```shell
for i in *.png; do
  ls -l $i
done
```

上面例子中，`*.png`会替换成当前目录中所有 PNG 图片文件，变量`i`会依次等于每一个文件。

列表也可以通过子命令产生。

```shell
#!/bin/bash

count=0
for i in $(cat ~/.bash_profile); do
  count=$((count + 1))
  echo "Word $count ($i) contains $(echo -n $i | wc -c) characters"
done
```

上面例子中，`cat ~/.bash_profile`命令会输出`~/.bash_profile`文件的内容，然后通过遍历每一个词，计算该文件一共包含多少个词，以及每个词有多少个字符。

### for 循环

`for`循环还支持 C 语言的循环语法。

```shell
for (( expression1; expression2; expression3 )); do
  commands
done
```

上面代码中，`expression1`用来初始化循环条件，`expression2`用来决定循环结束的条件，`expression3`在每次循环迭代的末尾执行，用于更新值。

注意，循环条件放在双重圆括号之中。另外，圆括号之中使用变量，不必加上美元符号`$`。

下面是一个例子。

```shell
for (( i=0; i<5; i=i+1 )); do
  echo $i
done
```

上面代码中，初始化变量`i`的值为0，循环执行的条件是`i`小于5。每次循环迭代结束时，`i`的值加1。

### break，continue

Bash 提供了两个内部命令`break`和`continue`，用来在循环内部跳出循环。

`break`命令立即终止循环，程序继续执行循环块之后的语句，即不再执行剩下的循环。

```shell
#!/bin/bash

for number in 1 2 3 4 5 6
do
  echo "number is $number"
  if [ "$number" = "3" ]; then
    break
  fi
done
```

上面例子只会打印3行结果。一旦变量`$number`等于3，就会跳出循环，不再继续执行。

`continue`命令立即终止本轮循环，开始执行下一轮循环。

```shell
#!/bin/bash

while read -p "What file do you want to test?" filename
do
  if [ ! -e "$filename" ]; then
    echo "The file does not exist."
    continue
  fi

  echo "You entered a valid file.."
done
```

上面例子中，只要用户输入的文件不存在，`continue`命令就会生效，直接进入下一轮循环（让用户重新输入文件名），不再执行后面的打印语句。

## Bash 函数

### 简介

函数（function）是可以重复使用的代码片段，有利于代码的复用。它与别名（alias）的区别是，别名只适合封装简单的单个命令，函数则可以封装复杂的多行命令。

函数总是在当前 Shell 执行，这是跟脚本的一个重大区别，Bash 会新建一个子 Shell 执行脚本。如果函数与脚本同名，函数会优先执行。但是，函数的优先级不如别名，即如果函数与别名同名，那么别名优先执行。

Bash 函数定义的语法有两种。

```shell
# 第一种
fn() {
  # codes
}

# 第二种
function fn() {
  # codes
}
```

上面代码中，`fn`是自定义的函数名，函数代码就写在大括号之中。这两种写法是等价的。

> 优先级：别名>函数>脚本

下面是一个简单函数的例子。

```shell
hello() {
  echo "Hello $1"
}
```

上面代码中，函数体里面的`$1`表示函数调用时的第一个参数。

查看当前 Shell 已经定义的所有函数，可以使用`declare`命令。

```shell
$ declare -f
```

### 参数变量

函数体内可以使用参数变量，获取函数参数。函数的参数变量，与脚本参数变量是一致的。

- `$1`~`$9`：函数的第一个到第9个的参数。
- `$0`：函数所在的脚本名。
- `$#`：函数的参数总数。
- `$@`：函数的全部参数，参数之间使用空格分隔。
- `$*`：函数的全部参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。

如果函数的参数多于9个，那么第10个参数可以用`${10}`的形式引用，以此类推。

下面是一个示例脚本`test.sh`。

```shell
#!/bin/bash
# test.sh

function alice {
  echo "alice: $@"
  echo "$0: $1 $2 $3 $4"
  echo "$# arguments"

}

alice in wonderland
```

### return 命令

`return`命令用于从函数返回一个值。函数执行到这条命令，就不再往下执行了，直接返回了。

```shell
function func_return_value {
  return 10
}
```

### 全局变量和局部变量，local 命令

**Bash 函数体内直接声明的变量，属于全局变量，整个脚本都可以读取。这一点需要特别小心。**

```shell
# 脚本 test.sh
fn () {
  foo=1
  echo "fn: foo = $foo"
}

fn
echo "global: foo = $foo"
```

上面脚本的运行结果如下。

```shell
$ bash test.sh
fn: foo = 1
global: foo = 1
```

函数里面可以用`local`命令声明局部变量。

```shell
#! /bin/bash
# 脚本 test.sh
fn () {
  local foo
  foo=1
  echo "fn: foo = $foo"
}

fn
echo "global: foo = $foo"
```

上面脚本的运行结果如下。

```shell
$ bash test.sh
fn: foo = 1
global: foo =
```

上面例子中，`local`命令声明的`$foo`变量，只在函数体内有效，函数体外没有定义。

## 数组

数组（array）是一个包含多个值的变量。成员的编号从0开始，数量没有上限，也没有要求成员被连续索引。

### 创建数组

数组可以采用逐个赋值的方法创建。也可以采用一次性赋值的方式创建。

```shell
ARRAY=(value1 value2 ... valueN)

# 等同于

ARRAY=(
  value1
  value2
  value3
)
```

先用`declare -a`命令声明一个数组，也是可以的。

```shell
$ declare -a ARRAYNAME
```

`read -a`命令则是将用户的命令行输入，读入一个数组。

```shell
$ read -a dice
```

上面命令将用户的命令行输入，读入数组`dice`。

### 读取数组

#### 读取单个元素

读取数组指定位置的成员，要使用下面的语法。

```shell
$ echo ${array[i]}     # i 是索引
```

#### 读取所有成员

`@`和`*`是数组的特殊索引，表示返回数组的所有成员。

```shell
$ foo=(a b c d e f)
$ echo ${foo[@]}
a b c d e f
```

这两个特殊索引配合`for`循环，就可以用来遍历数组。

```shell
for i in "${names[@]}"; do
  echo $i
done
```

`@`和`*`放不放在双引号之中，是有差别的。

```shell
$ activities=( swimming "water skiing" canoeing "white-water rafting" surfing )
$ for act in ${activities[@]}; \
do \
echo "Activity: $act"; \
done

Activity: swimming
Activity: water
Activity: skiing
Activity: canoeing
Activity: white-water
Activity: rafting
Activity: surfing
```

上面的例子中，数组`activities`实际包含5个元素，但是`for...in`循环直接遍历`${activities[@]}`，会导致返回7个结果。为了避免这种情况，一般把`${activities[@]}`放在双引号之中。

```shell
$ for act in "${activities[@]}"; \
do \
echo "Activity: $act"; \
done

Activity: swimming
Activity: water skiing
Activity: canoeing
Activity: white-water rafting
Activity: surfing
```

上面例子中，`${activities[@]}`放在双引号之中，遍历就会返回正确的结果。

`${activities[*]}`不放在双引号之中，跟`${activities[@]}`不放在双引号之中是一样的。

```shell
$ for act in ${activities[*]}; \
do \
echo "Activity: $act"; \
done

Activity: swimming
Activity: water
Activity: skiing
Activity: canoeing
Activity: white-water
Activity: rafting
Activity: surfing
```

`${activities[*]}`放在双引号之中，所有元素就会变成单个字符串返回。

```shell
$ for act in "${activities[*]}"; \
do \
echo "Activity: $act"; \
done

Activity: swimming water skiing canoeing white-water rafting surfing
```

### 数组的长度

要想知道数组的长度（即一共包含多少成员），可以使用下面两种语法。

```
${#array[*]}
${#array[@]}
```

### 提取数组序号

`${!array[@]}`或`${!array[*]}`，可以返回数组的成员序号，即哪些位置是有值的。

```shell
$ arr=([5]=a [9]=b [23]=c)
$ echo ${!arr[@]}
5 9 23
$ echo ${!arr[*]}
5 9 23
```

上面例子中，数组的5、9、23号位置有值。

### 提取数组成员

`${array[@]:position:length}`的语法可以提取数组成员。

```shell
$ food=( apples bananas cucumbers dates eggs fajitas grapes )
$ echo ${food[@]:1:2}
bananas
$ echo ${food[@]:4}
eggs fajitas grapes
```

上面例子中，`${food[@]:1:2}`返回从数组1号位置开始的3个成员。

如果省略长度参数`length`，则返回从指定位置开始的所有成员。

### 追加数组成员

数组末尾追加成员，可以使用`+=`赋值运算符。它能够自动地把值追加到数组末尾。否则，就需要知道数组的最大序号，比较麻烦。

```shell
$ foo=(a b c)
$ echo ${foo[@]}
a b c

$ foo+=(d e f)
$ echo ${foo[@]}
a b c d e f
```

### 删除数组

删除一个数组成员，使用`unset`命令。

```shell
$ foo=(a b c d e f)
$ echo ${foo[@]}
a b c d e f

$ unset foo[2]
$ echo ${foo[@]}
a b d e f
```

上面例子中，删除了数组中的第三个元素，下标为2。

### 关联数组 Hash

Bash 的新版本支持关联数组。关联数组使用字符串而不是整数作为数组索引。

`declare -A`可以声明关联数组。

```shell
declare -A colors
colors["red"]="#ff0000"
colors["green"]="#00ff00"
colors["blue"]="#0000ff"
```

整数索引的数组，可以直接使用变量名创建数组，关联数组则必须用带有`-A`选项的`declare`命令声明创建。

访问关联数组成员的方式，几乎与整数索引数组相同。

```shell
echo ${colors["blue"]}
```

## set 命令

`set`命令是 Bash 脚本的重要环节，却常常被忽视，导致脚本的安全性和可维护性出问题。本章介绍`set`的基本用法，帮助你写出更安全的 Bash 脚本。

## 简介

我们知道，Bash 执行脚本时，会创建一个子 Shell。

```shell
$ bash script.sh
```

上面代码中，`script.sh`是在一个子 Shell 里面执行。这个子 Shell 就是脚本的执行环境，Bash 默认给定了这个环境的各种参数。

`set`命令用来修改子 Shell 环境的运行参数，即定制环境。一共有十几个参数可以定制，[官方手册](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)有完整清单，本章介绍其中最常用的几个。

顺便提一下，如果命令行下不带任何参数，直接运行`set`，会显示所有的环境变量和 Shell 函数。

```shell
$ set
```

### set -u

执行脚本时，如果遇到不存在的变量，Bash 默认忽略它。

```shell
#!/usr/bin/env bash

echo $a
echo bar
```

上面代码中，`$a`是一个不存在的变量。执行结果如下。

```shell
$ bash script.sh

bar
```

可以看到，`echo $a`输出了一个空行，Bash 忽略了不存在的`$a`，然后继续执行`echo bar`。大多数情况下，这不是开发者想要的行为，遇到变量不存在，脚本应该报错，而不是一声不响地往下执行。

`set -u`就用来改变这种行为。脚本在头部加上它，遇到不存在的变量就会报错，并停止执行。

```shell
#!/usr/bin/env bash
set -u

echo $a
echo bar
```

运行结果如下。

```shell
$ bash script.sh
bash: script.sh:行4: a: 未绑定的变量
```

### set -x

默认情况下，脚本执行后，只输出运行结果，没有其他内容。如果多个命令连续执行，它们的运行结果就会连续输出。有时会分不清，某一段内容是什么命令产生的。

`set -x`用来在运行结果之前，先输出执行的那一行命令。

```shell
#!/usr/bin/env bash
set -x

echo bar
```

执行上面的脚本，结果如下。

```shell
$ bash script.sh
+ echo bar
bar
```

可以看到，执行`echo bar`之前，该命令会先打印出来，行首以`+`表示。这对于调试复杂的脚本是很有用的。

### set -o pipefail

`set -e`有一个例外情况，就是不适用于管道命令。

所谓管道命令，就是多个子命令通过管道运算符（`|`）组合成为一个大的命令。Bash 会把最后一个子命令的返回值，作为整个命令的返回值。也就是说，只要最后一个子命令不失败，管道命令总是会执行成功，因此它后面命令依然会执行，`set -e`就失效了。

请看下面这个例子。

```
#!/usr/bin/env bash
set -e

foo | echo a
echo bar
```

执行结果如下。

```
$ bash script.sh
a
script.sh:行4: foo: 未找到命令
bar
```

上面代码中，`foo`是一个不存在的命令，但是`foo | echo a`这个管道命令会执行成功，导致后面的`echo bar`会继续执行。

`set -o pipefail`用来解决这种情况，只要一个子命令失败，整个管道命令就失败，脚本就会终止执行。

```
#!/usr/bin/env bash
set -eo pipefail

foo | echo a
echo bar
```

运行后，结果如下。

```
$ bash script.sh
a
script.sh:行4: foo: 未找到命令
```

## mktemp 命令，trap 命令

Bash 脚本有时需要创建临时文件或临时目录。常见的做法是，在`/tmp`目录里面创建文件或目录，这样做有很多弊端，使用`mktemp`命令是最安全的做法。

### 临时文件的安全问题

直接创建临时文件，尤其在`/tmp`目录里面，往往会导致安全问题。

### mktemp 命令的用法

`mktemp`命令就是为安全创建临时文件而设计的。虽然在创建临时文件之前，它不会检查临时文件是否存在，但是它支持唯一文件名和清除机制，因此可以减轻安全攻击的风险。

直接运行`mktemp`命令，就能生成一个临时文件。

```shell
$ mktemp
/tmp/tmp.4GcsWSG4vj

$ ls -l /tmp/tmp.4GcsWSG4vj
-rw------- 1 ruanyf ruanyf 0 12月 28 12:49 /tmp/tmp.4GcsWSG4vj
```

上面命令中，`mktemp`命令生成的临时文件名是随机的，而且权限是只有用户本人可读写。

Bash 脚本使用`mktemp`命令的用法如下。

```shell
#!/bin/bash

TMPFILE=$(mktemp) || exit 1
echo "Our temp file is $TMPFILE"
```

为了保证脚本退出时临时文件被删除，可以使用`trap`命令指定退出时的清除操作。

```shell
#!/bin/bash

trap 'rm -f "$TMPFILE"' EXIT

TMPFILE=$(mktemp) || exit 1
echo "Our temp file is $TMPFILE"
```

上面命令中，脚本遇到`EXIT`信号时，就会执行`rm -f "$TMPFILE"`。

`-d`参数可以创建一个临时目录。

```shell
$ mktemp -d
/tmp/tmp.Wcau5UjmN6
```

`-p`参数可以指定临时文件所在的目录。默认是使用`$TMPDIR`环境变量指定的目录，如果这个变量没设置，那么使用`/tmp`目录。

```shell
$ mktemp -p /home/ruanyf/
/home/ruanyf/tmp.FOKEtvs2H3
```

`-t`参数可以指定临时文件的文件名模板，模板的末尾必须至少包含三个连续的`X`字符，表示随机字符，建议至少使用六个`X`。默认的文件名模板是`tmp.`后接十个随机字符。

```shell
$ mktemp -t mytemp.XXXXXXX
/tmp/mytemp.yZ1HgZV
```

## Bash 启动环境

### Session

用户每次使用 Shell，都会开启一个与 Shell 的 Session（对话）。

Session 有两种类型：登录 Session 和非登录 Session，也可以叫做 login shell 和 non-login shell。

### 登录 Session

登录 Session 是用户登录系统以后，系统为用户开启的原始 Session，通常需要用户输入用户名和密码进行登录。

登录 Session 一般进行整个系统环境的初始化，启动的初始化脚本依次如下。

- `/etc/profile`：所有用户的全局配置脚本。
- `/etc/profile.d`目录里面所有`.sh`文件
- `~/.bash_profile`：用户的个人配置脚本。如果该脚本存在，则执行完就不再往下执行。
- `~/.bash_login`：如果`~/.bash_profile`没找到，则尝试执行这个脚本（C shell 的初始化脚本）。如果该脚本存在，则执行完就不再往下执行。
- `~/.profile`：如果`~/.bash_profile`和`~/.bash_login`都没找到，则尝试读取这个脚本（Bourne shell 和 Korn shell 的初始化脚本）。

Linux 发行版更新的时候，会更新`/etc`里面的文件，比如`/etc/profile`，因此不要直接修改这个文件。如果想修改所有用户的登陆环境，就在`/etc/profile.d`目录里面新建`.sh`脚本。

### 非登录 Session

非登录 Session 是用户进入系统以后，手动新建的 Session，这时不会进行环境初始化。比如，在命令行执行`bash`命令，就会新建一个非登录 Session。

非登录 Session 的初始化脚本依次如下。

- `/etc/bash.bashrc`：对全体用户有效。
- `~/.bashrc`：仅对当前用户有效。

对用户来说，`~/.bashrc`通常是最重要的脚本。非登录 Session 默认会执行它，而登录 Session 一般也会通过调用执行它。每次新建一个 Bash 窗口，就相当于新建一个非登录 Session，所以`~/.bashrc`每次都会执行。

> 注意，执行脚本相当于新建一个非互动的 Bash 环境，但是这种情况不会调用`~/.bashrc`。

## 键盘绑定

Bash 允许用户定义自己的快捷键。全局的键盘绑定文件默认为`/etc/inputrc`，你可以在主目录创建自己的键盘绑定文件`.inputrc`文件。如果定义了这个文件，需要在其中加入下面这行，保证全局绑定不会被遗漏。

```shell
set editing-mode vi
```

使用 vi 编辑模式。