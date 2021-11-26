## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 03-sysadmin-04-os. 3.4. Операционные системы, лекция 2

#### 1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

+ поместите его в автозагрузку,
+ предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
+ удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Ответ:

Создан unit, добавлен в атозагрузку:

```
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

```
Проверка статуса:

```
vagrant@vagrant:/etc/systemd/system$ systemctl status node_exporter.service
  node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-11-24 19:57:31 UTC; 18min ago
   Main PID: 1621 (node_exporter)
      Tasks: 6 (limit: 1983)
     Memory: 6.4M
     CGroup: /system.slice/node_exporter.service
             └─1621 /usr/local/bin/node_exporter

```

Создан конфиг с переменной $NE_OPTS и опциями в /etc/node_exporter/node_exporter.conf   

В юните, через EnvironmentFile добавлен config :

```
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter

EnvironmentFile=/etc/node_exporter/node_exporter.conf
ExecStart=/usr/local/bin/node_exporter $NE_OPTS

SyslogIdentifier=node_exporter
Restart=always

PrivateTmp=yes
ProtectHome=yes
NoNewPrivileges=yes

ProtectSystem=strict
ProtectControlGroups=true
ProtectKernelModules=true
ProtectKernelTunables=yes

[Install]
WantedBy=multi-user.target

```

---
#### 2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ:

--collector.disable-defaults --collector.cpu --collector.meminfo --collector.diskstats --collector.netdev --collector.netstat

---

#### 3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). После успешной установки:

в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999

Ответ:

Установлено :

```
vagrant@vagrant:~$ systemctl status netdata | head -n3

● netdata.service - netdata - Real-time performance monitoring
     Loaded: loaded (/lib/systemd/system/netdata.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2021-11-25 15:14:34 UTC; 1h 41min ago

```

Порт проброшен , соединение установлено с хостовой машины:

```
vagrant@vagrant:~$ sudo ss -tapn | grep -i netdata

LISTEN    0         4096               0.0.0.0:19999            0.0.0.0:*        users:(("netdata",pid=795,fd=4))
LISTEN    0         4096             127.0.0.1:8125             0.0.0.0:*        users:(("netdata",pid=795,fd=37))
ESTAB     0         0                10.0.2.15:19999           10.0.2.2:45560    users:(("netdata",pid=795,fd=52))
LISTEN    0         4096                 [::1]:8125                [::]:*        users:(("netdata",pid=795,fd=36))

```

На хостовой машине через браузер доступен localhost:19999 :   

![netdata](/03-sysadmin-04-os/net_data.jpg "netdata")


---

#### 4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Ответ:
Да:

```
vagrant@vagrant:~$ dmesg | grep -i DMI
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006

```
```
vagrant@vagrant:~$ dmesg | grep -i virtual
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.001435] CPU MTRRs all blank - virtualized system.
[    0.076123] Booting paravirtualized kernel on KVM
[    2.251161] systemd[1]: Detected virtualization oracle.

```

---

#### 5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

Ответ:

fs.nr_open - Это ограничение на количестов открытых файловых дескрипторов для процесса.  
Значение по умолчанию : 1048576 (1024*1024) . 

ulimit - n  (-n the maximum number of open file descriptors)  

___

#### 6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

Ответ:

В pts0 :

```
root@vagrant:~# unshare -f -p --mount-proc sleep 10m

```
В pts2 :

```
root@vagrant:~# nsenter --target 3669 --mount --uts --ipc --net --pid ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   9828   592 pts/0    S+   00:34   0:00 sleep 10m

```

---

#### 7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Ответ:

Это так называемая bash fork() bomb. Возможен DoS, вследствие нехватки системных ресурсов (дескрипторов процессов, памяти, процессорного времени).
fork() bomb порождает большое количество собственных копий и тем самым пытается заполнить свободное место в списке активных процессов операционной системы.

  :() – Объявляется функция с именем ":".    
  :|: – Рекурсивный вызов функции и передача вывода для другого вызова этой же функции ":".  
  & – Запуск в фоне, таким образом потомки не могут быть завершены и начинается нарастающее потребление системных ресурсов.  
  ; – Завершение определения функции   
  : - снова вызов этой же функции ":" но на переднем плане   

Ограничение процессов на сессию пользователя и изменение :  
```
vagrant@vagrant:~$ ulimit -u
6613
vagrant@vagrant:~$ ulimit -S -u 50

```

root@vagrant:~# dmesg | grep fork
[35311.357424] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-16.scope

---
