## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 04-script-02-py. 4.2. Использование Python для решения типовых DevOps задач

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | ошибка, т.к. между операндом "+" стоят переменные с неподдерживаемым типом для данной операции : а- int, b- строка  |
| Как получить для переменной `c` значение 12?  | Присвоить переменной a значение '1', тогда, через операнд "+" выполнится объединение двух строк '1' и '2' и получим 12 (тип будет str). Либо, менять переменную с так:  c = str(a) + b |
| Как получить для переменной `c` значение 3?  | Присвоить переменной b значение 2 (без кавычек), тогда, через операнд "+" выполнится операция сложения 1+2 и получим 3 (тип будет int). Либо, менять переменную с так: c = a + int(b) |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os

git_repo = "~/netology/sysadm-homeworks"
git_status = "git status --short"
home = os.path.expanduser(git_repo)
git_cmd = ["cd " + git_repo, git_status]
git_result = os.popen(' && '.join(git_cmd)).read().rstrip().split('\n')
print('Checking files with status "modified(M)" ...', '\n', 'Result:')
for result in git_result:
    if result.find('M ') != -1:
        prepare_result = result.replace(' M ', '')
        print(f'\033[31m{home}/{prepare_result}')
    else:
        print('Files with status "modified" is not found', '\n', 'Exit ...')
        break
        
```

### Вывод скрипта при запуске при тестировании:
```
$ ../python/modified.py
Checking files with status "modified(M)" ... 
 Result:
/home/leo/netology/sysadm-homeworks/mod
/home/leo/netology/sysadm-homeworks/testfile
/home/leo/netology/sysadm-homeworks/testfile2
/home/leo/netology/sysadm-homeworks/testfile3

$ git commit -a -m "added all modified files"  
[main c25ff4f] added all modified files
 4 files changed, 4 insertions(+), 8 deletions(-)
 
$ ../python/modified.py
Checking files with status "modified(M)" ... 
 Result:
Files with status "modified" is not found 
 Exit ...

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
import sys

git_repo = os.getcwd()
git_status = 'git status --short 2>&1'
git_check = os.popen(git_status).read()
if git_check.find('fatal') != -1 and len(sys.argv) == 1:
    print('path: ' + git_repo + '  is not git repo \nExit ...')
    sys.exit(1)
if len(sys.argv) == 1:
    print('\nWorking with current dir : "."')
else:
    if len(sys.argv) <= 2:
        git_repo = sys.argv[1]
    if not os.path.exists(git_repo):
        print('Dir: ' + git_repo + '  Does not exist \nExit ...')
        sys.exit(1)
    if len(sys.argv) >= 3:
        print("Error. Too many parameters. ")
        sys.exit(1)
git_cmd = ["cd " + git_repo, git_status]
git_result = os.popen(' && '.join(git_cmd)).read().rstrip().split('\n')
print(f'\nChecking files with status "modified(M)" in {git_repo}', '\n', 'Result:')
for result in git_result:
    if result.find(' M ') != -1:
        prepare_result = result.replace(' M ', '')
        print(f'\033[31m{git_repo}/{prepare_result}')
    else:
        print('Files with status "modified" is not found', '\n', 'Exit ...')
        break

```

### Вывод скрипта при запуске при тестировании:
```
#Без параметра. Проверка папки не являющейся гит репозиторием 
$ cd /tmp/
$ python3 ~/netology/python/modified2/modified2.py
path: /tmp  is not git repo 
Exit ...

#Без параметра. Запуск в гит репозитории 
$ cd ~/netology/sysadm-homeworks/
$ python3 ~/netology/python/modified2/modified2.py

Working with current dir : "."

Checking files with status "modified(M)" in /home/leo/netology/sysadm-homeworks 
 Result:
/home/leo/netology/sysadm-homeworks/1/11
/home/leo/netology/sysadm-homeworks/M
/home/leo/netology/sysadm-homeworks/mod
/home/leo/netology/sysadm-homeworks/testfile2

#C параметром. Запуск из любой папки . Передача "ошибочного" пути
$ cd /tmp/
$ python3 ~/netology/python/modified2/modified2.py ~/netology/sysadm-home12
Dir: /home/leo/netology/sysadm-home12  Does not exist 
Exit ...

#C параметром. Запуск из любой папки . Передача пути до гит репозитория
$ cd /tmp/
$ python3 ~/netology/python/modified2/modified2.py ~/netology/sysadm-homeworks

Checking files with status "modified(M)" in /home/leo/netology/sysadm-homeworks 
 Result:
/home/leo/netology/sysadm-homeworks/1/11
/home/leo/netology/sysadm-homeworks/M
/home/leo/netology/sysadm-homeworks/mod
/home/leo/netology/sysadm-homeworks/testfile2

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```
