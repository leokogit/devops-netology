## Курсовая работа по итогам модуля "DevOps и системное администрирование". pcs-devsys-diplom. Кожаев Л.С. 

## Процесс установки и настройки ufw

ufw установлен: 
```
$ ufw version
ufw 0.36
Copyright 2008-2015 Canonical Ltd.
```

Добавление дефолтных правил: 
```
$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)

$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
```
Разрешаем входящие на 22 и 443 порт:
```
$ sudo ufw allow from 192.168.1.0/24 to any port ssh
Rule added

$ sudo ufw allow from 192.168.1.0/24 to any port https
Rule added
```
Проверяем правила:

```
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.1.0/24
443/tcp                    ALLOW IN    192.168.1.0/24

```

## Процесс установки и выпуска сертификата с помощью hashicorp vault

Скачиваем deb пакет (ставим на Ubuntu) и устанавливаем:
```bash

$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

$ sudo apt-get update && sudo apt-get install vault

```

## Процесс установки и настройки сервера nginx
 
### 55:
```bash

```

## Страница сервера nginx в браузере хоста не содержит предупреждений


### крипт:
```bash
???

```

## Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")


### скрипт:
```bash
???
```

## Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)


### Ваш скрипт:
```bash
???
```
