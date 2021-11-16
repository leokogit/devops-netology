## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ 03-sysadmin-01-terminal. 3.1. Работа в терминале, лекция 1
#### 5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
+ Memory size:                 1024MB    
+ Number of CPUs:              2 
+ VRAM size:                   4MB
---
#### 6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
Заходим в папку c vagrant (где запускался vagrant init), правим Vagrantfile:
>`$ vim Vagrantfile`  
    Vagrant.configure("2") do |config|    
            config.vm.box = "bento/ubuntu-20.04"    
    \# Define RAM size and CPU count          
            config.vm.provider "virtualbox" do |v|  
            v.memory = 512  
            v.cpus = 1  
     end   
    end
---
#### 8.  Ознакомиться с разделами man bash, почитать о настройках самого bash:
+ какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
    
> Для ограничения размера файла журнала history (который сохраняется после выхода из сессии):   
> Переменная: HISTFILESIZE , строка 642 или 2325     
> Для ограничения истории, которая хранится временно, в памяти (кол-во команд, которые мы можем хранить во время сессии) 
> Переменная: HISTSIZE , строка 2325 (если искать по ключевому слову HISTORY) и  строка 646 (если искать по HISTSIZE)    
+ что делает директива ignoreboth в bash?

> Содержит в себе оба правила ignorespace and ignoredups, т.е. не сохранять команды, которые начинаются с пробела и команду которая дублирует предыдущую. 
---
#### 9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?    
> Строка 805. Фигурные скобки применимы для операций с файлами (создание, копирование, удаление) или изменение прав, когда нужно указать сразу несколько файлов или задать диапазон.   
---
#### 10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

 `touch {1..100000}.txt`
 
Без изменения размера стека нет. Чтобы создать 300000 файлов нужно выполнить команды:

Посмотреть текущие ограничения размера стека

`ulimit -a`
```
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 5438
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 5438
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited  
```

`getconf ARG_MAX`
>2097152
> 
Установить новое значение    
 `ulimit -s 65536`  

Посмотреть изменение    

`ulimit -a |grep stack`     

>stack size              (kbytes, -s) 65536    

`getconf ARG_MAX`   
>16777216
   
Далее можно создать 300000 файлов командой:

`touch {1..300000}.txt`

Для постоянного внесения изменений (глобально), касательно ограничений, надо править /etc/security/limits.conf

---
#### 11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]   
> В данной конструкции аргументы воспринимаются как выражение сравнения или как файловая проверка и возвращается код завершения в соответствии с результатами проверки (0 -- истина, 1 -- ложь)     
> В конкретном случае проверяется существует ли файл /tmp и является ли он каталогом (-d)
```
#!/bin/bash
if [[ -d /tmp ]]
then
  echo "/tmp существует и является каталогом"
fi
```
---
#### 11. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

- bash is /tmp/new_path_directory/bash
- bash is /usr/local/bin/bash
- bash is /bin/bash
  
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

```
vagrant@vagrant:~$ mkdir -p /tmp/new_path_directory/
vagrant@vagrant:~$ ln -s /bin/bash /tmp/new_path_directory/bash
vagrant@vagrant:~$ PATH=/tmp/new_path_directory/:$PATH
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```
Или 

```
vagrant@vagrant:~$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:~$ mkdir -p /tmp/new_path_directory/
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory/
vagrant@vagrant:~$ PATH=/tmp/new_path_directory/:$PATH
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```

---
#### 13. Чем отличается планирование команд с помощью batch и at?

> **at** запускает команду в указанное время    
> **batch** выполняет задание когда среднее значение нагрузки падает ниже 1,5 или значения, указанного в вызове atd. Задание ставится в очередь и запускается как только у системы высвобождаются ресурсы. 


