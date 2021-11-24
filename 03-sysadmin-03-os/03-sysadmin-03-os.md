## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 03-sysadmin-03-os. 3.3 Операционные системы, лекция 1

#### 1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.

> chdir("/tmp")

---
#### 2. Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.

Согласно `man file`   (поиск по ключевому слову "base") будет производится сравнение магических номеров (файловых сигнатур) и соответсвующих записей в этих файлах:

/etc/magic
/usr/share/misc/magic.mgc
/usr/share/misc/magic
$HOME/.magic.mgc
$HOME/.magic

> Предварительно создал текстовый файл для проверки 
`echo "It's text file" > /tmp/2.txt `   
> Запустил strace   
`strace file /tmp/2.txt`    

`strace` Показал, что была произведена проверка по всем файлам указанным в списке выше, т.к. магический номер для искомого файла не был найден, было определено что тип файла text/plain    

(об этом говорит строчка из man file "...If a file does not match any of the entries in the magic file, it is examined to see if it seems to be a text file.)   

---

#### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

> `cat /dev/null > /proc/14512/fd/3` где 14512 PID процесса который пишет в уадлённый файл с дескриптором 3    
>  
> Если файл слишком быстро растёт и надо остановить это, можно опопробовать запустить в фоне другой процесс, где циклично писать из dev/null в дескриптор удалённого файла :    
`while true; do cat /dev/null > /proc/14512/fd/3; done &`   

либо : `truncate -s 0 /proc/14512/fd/3` 

---

#### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

> Зомби не занимают ресурсы, но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы. При достижении лимита записей все процессы пользователя, от имени которого выполняется создающий зомби родительский процесс, не будут способны создавать новые дочерние процессы.

---

#### 5. В iovisor BCC есть утилита opensnoop:
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04.

```
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
783    vminfo              5   0 /var/run/utmp
585    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
585    dbus-daemon        18   0 /usr/share/dbus-1/system-services
585    dbus-daemon        -1   2 /lib/dbus-1/system-services
585    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/

```

___

#### 6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

> uname ()      
> `man 2 uname` :   
> "Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}." 

---

#### 7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:

    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#

    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

> Через ";" Команды будут выполняться последовательно и независимо от успеха выполнения предыдущих команд (указанные до оператора ";")      
> Через "&&" Следущая команда, указанная после этого оператора, будет выполнена только если предыдущая команда отработала успешно       
> Использовать или нет, наверное зависит от заложенной логики и необходимого поведения.     

> set -e останавливает выполнение сценария, если в команде или конвейере есть ошибка. Но(!) будет игнорироваться при определённых способах использовании оператора "&&" (в частности).      

из man bash касательно set -e :     

"The shell does not exit if the command that fails is part of the command list immediately following a while or until keyword, part of the test following the if or elif reserved words, part of any command executed in a && or || list except the command following the final && or ||, any command in a pipeline but the last, or if the command's return value is being inverted with !. If a compound command other than a subshell returns a non-zero status because a command failed while -e was being ignored, the shell does not exit. A trap on ERR, if set, is executed before the shell exits. This option applies to the shell environment and each sub-shell environment separately (see COMMAND EXECUTION ENVIRONMENT above), and may cause subshells to exit before executing all the commands in the subshell."   

---

#### 8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?  

+ set -e     Скрипт немедленно завершит работу, если любая команда выйдет с ошибкой. По-умолчанию, игнорируются любые неудачи и сценарий продолжет выполнятся.
+ set -u     Проверка инициализации переменных в скрипте. Если переменной не будет, скрипт немедленно завершиться.
+ set -x     Печать в стандартный вывод всех команд перед их исполнением.
+ set -o pipefail Если нужно убедиться, что все команды в пайпах завершились успешно 

Для отказоустойчивости и отладки сценария

---

#### 9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

> S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения (спящие процессы с возможностью прерывания)
> I*(I,I<) - бездействующие потоки ядра

---
