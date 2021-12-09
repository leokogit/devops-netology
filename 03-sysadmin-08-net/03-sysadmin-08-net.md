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
  Refresh Epoch 1
  20130 6939 31133 25159
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE134E95128 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 174 31133 25159
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:3 3356:22 3356:86 3356:575 3356:666 3356:901 3356:2012
      path 7FE10D986368 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 174 31133 25159
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:3 3356:22 3356:86 3356:575 3356:666 3356:901 3356:2011 3549:2581 3549:30840
      path 7FE133D4EAC0 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 11164 2603 31133 25159
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 0:714 0:2854 0:3216 0:5580 0:6461 0:6939 0:8075 0:8359 0:9002 0:12389 0:12876 0:12989 0:13335 0:15169 0:16265 0:16276 0:16302 0:16509 0:16625 0:20485 0:20764 0:20940 0:21859 0:22697 0:24940 0:32338 0:32590 0:33438 0:33891 0:39832 0:42668 0:46489 0:47541 0:47542 0:49544 0:49981 0:56550 0:56630 0:57976 0:60280 101:20100 101:22100 2603:302 2603:666 2603:65101 11164:1170 11164:7880 25159:10 25159:4037
      Extended Community: RT:101:22100
      path 7FE088D878A8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 31133 25159
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0F91835D0 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 31133 25159
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 25159:10 25159:4037
      path 7FE133DBE768 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 174 31133 25159
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE0C7E2B478 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 174 31133 25159
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30155 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE0DF8A6518 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 3
  3303 31133 25159
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1006 3303:1030 3303:3056 25159:10 25159:4037
      path 7FE0942E52D8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 31133 25159
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE14C78FC48 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 174 31133 25159
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9001
      path 7FE162C76CA8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 174 31133 25159
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8059 3257:30153 3257:50001 3257:54900 3257:54901
      path 7FE0B8AD3E20 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 174 31133 25159
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE021017028 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 31133 25159
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE12FD62650 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 31133 25159
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external, best
      Community: 8283:1 8283:101 8283:103 25159:10 25159:4037
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 0000 205B 0000 0005
              0000 0003
      path 7FE10F5CBC50 RPKI State valid
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  1221 4637 31133 25159
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE178562768 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 174 31133 25159
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0F9AFAA08 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 209 3356 174 31133 25159
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE17200C7C8 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 31133 25159
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE1859A2008 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 31133 25159
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE025EEC8E0 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  19214 174 31133 25159
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22028
      path 7FE10C63A4D0 RPKI State valid
      rx pathid: 0, tx pathid: 0

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


```


```

---
