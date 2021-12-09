## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 03-sysadmin-08-net. 3.8. Компьютерные сети, лекция 3

#### 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

```
telnet route-views.routeviews.org
Username: rviews

route-views>show ip route 85.26.155.60
Routing entry for 85.26.144.0/20
  Known via "bgp 6447", distance 20, metric 0
  Tag 8283, type external
  Last update from 94.142.247.3 04:47:01 ago
  Routing Descriptor Blocks:
  * 94.142.247.3, from 94.142.247.3, 04:47:01 ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 8283
      MPLS label: none

route-views>show bgp 85.26.155.60
BGP routing table entry for 85.26.144.0/20, version 1407150930
Paths: (23 available, best #17, table default)
  Not advertised to any peer
  Refresh Epoch 1
  53767 174 31133 25159
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22028 53767:5000
      path 7FE1531BDF48 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 6830 174 31133 25159
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 6830:17000 6830:17504 6830:33125 17152:0 57866:501
      path 7FE01AB0CE30 RPKI State valid
      rx pathid: 0, tx pathid: 0
      
***
```
---

#### 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

Ответ:

```
$ sudo modprobe -v dummy numdummies=2
$ sudo ip addr add 10.10.10.1/24 dev dummy0
$ sudo ip addr add 20.20.20.1/24 dev dummy1

$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64
vlan10@eth0      UP             10.0.0.15/24 fe80::a00:27ff:fe73:60cf/64
dummy0           DOWN           10.10.10.1/24
dummy1           DOWN           20.20.20.1/24

Стат маршруты:

vagrant@vagrant:~$ sudo ip route add 192.168.1.0/24 via 10.0.2.15
vagrant@vagrant:~$ sudo ip route add 192.168.2.0/24 via 10.0.2.15
vagrant@vagrant:~$ ip -br r
default via 10.0.0.1 dev vlan10 proto static
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.0.0/24 dev vlan10 proto kernel scope link src 10.0.0.15
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.1.0/24 via 10.0.2.15 dev eth0
192.168.2.0/24 via 10.0.2.15 dev eth0


```

---

#### 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

Ответ:

```
$ ss -ltn
State         Recv-Q        Send-Q               Local Address:Port                 Peer Address:Port        Process
LISTEN        0             4096                       0.0.0.0:111                       0.0.0.0:*
LISTEN        0             4096                 127.0.0.53%lo:53                        0.0.0.0:*
LISTEN        0             128                        0.0.0.0:22                        0.0.0.0:*
LISTEN        0             4096                          [::]:111                          [::]:*
LISTEN        0             128                           [::]:22                           [::]:*

```
Примеры и какие протоколы иприложения используют порты:

```
$ sudo ss -tapn
State   Recv-Q  Send-Q   Local Address:Port    Peer Address:Port  Process
LISTEN  0       4096         127.0.0.1:8125         0.0.0.0:*      users:(("netdata",pid=2111,fd=38))
LISTEN  0       4096         127.0.0.1:19999        0.0.0.0:*      users:(("netdata",pid=2111,fd=4))
LISTEN  0       4096           0.0.0.0:111          0.0.0.0:*      users:(("rpcbind",pid=563,fd=4),("systemd",pid=1,fd=86))
LISTEN  0       4096     127.0.0.53%lo:53           0.0.0.0:*      users:(("systemd-resolve",pid=564,fd=13))
LISTEN  0       128            0.0.0.0:22           0.0.0.0:*      users:(("sshd",pid=843,fd=3))
ESTAB   0       0            10.0.2.15:22          10.0.2.2:39664  users:(("sshd",pid=1114,fd=4),("sshd",pid=1067,fd=4))
LISTEN  0       4096             [::1]:8125            [::]:*      users:(("netdata",pid=2111,fd=37))
LISTEN  0       4096              [::]:111             [::]:*      users:(("rpcbind",pid=563,fd=6),("systemd",pid=1,fd=88))
LISTEN  0       128               [::]:22              [::]:*      users:(("sshd",pid=843,fd=4))


Порт 19999 используется  netdata
Порт 22 используется sshd (протокол ssh)
Порт 111 - SUNRPC (rpcbind)
Порт 53 - DNS (systemd-resolve)

```

---

#### 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

Ответ:

```
$ ss -lupan
State     Recv-Q    Send-Q         Local Address:Port        Peer Address:Port   Process
***
UNCONN    0         0               10.14.254.22:52207            0.0.0.0:*       users:(("chrome",pid=144736,fd=105))
UNCONN    0         0                224.0.0.251:5353             0.0.0.0:*       users:(("chrome",pid=144736,fd=203))
UNCONN    0         0                224.0.0.251:5353             0.0.0.0:*       users:(("chrome",pid=144736,fd=177))
UNCONN    0         0                224.0.0.251:5353             0.0.0.0:*       users:(("chrome",pid=144784,fd=63))
UNCONN    0         0                224.0.0.251:5353             0.0.0.0:*       users:(("chrome",pid=144784,fd=42))
***

```
Порт 5353 использует chrome , протокол mdns
___

#### 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

Ответ:

![diagrams](/03-sysadmin-08-net/draw.png "net")


---
