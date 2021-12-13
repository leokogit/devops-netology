## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 03-sysadmin-08-net. 3.9. Элементы безопасности информационных систем

#### 1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.  

Ответ:    

![bitwarden](/03-sysadmin-09-security/bit.jpg "bitwarden")

---

#### 2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

Ответ:

![auth](/03-sysadmin-09-security/auth.jpg "auth")

---

#### 3.Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

Ответ:

![apache](/03-sysadmin-09-security/apache2.jpg "apache")

---

#### 4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

Ответ:

```
$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
$ cd testssl.sh/
$ bash testssl.sh -U --sneaky https://localhost:8080

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (2201a28 2021-12-13 18:24:34 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.1.1l  24 Aug 2021" [~98 ciphers]
 on l-pc:/usr/bin/openssl
 (built: "Nov 24 09:53:29 2021", platform: "debian-amd64")


 Start 2021-12-13 23:54:30        -->> 127.0.0.1:8080 (localhost) <<--

 A record via:           /etc/hosts 
 rDNS (127.0.0.1):       localhost.
 Service detected:       HTTP


 Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=2E93A76500405C50EEC036F9469578C19A5A1EA7902261EB305B0AFD8218CF12 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      common prime with 2048 bits detected: RFC3526/Oakley Group 14 (2048 bits),
                                           but no DH EXPORT ciphers
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-13 23:54:54 [  25s] -->> 127.0.0.1:8080 (localhost) <<--

```
___

#### 5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

Ответ:

Проверяем установку ssh-server и создаём ключ:  

```
vagrant@vag:~$ sudo apt list -i 2>/dev/null | grep ssh-server
openssh-server/focal-updates,now 1:8.2p1-4ubuntu0.3 amd64 [installed]

vagrant@vag:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/vagrant/.ssh/id_rsa
Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:NPeCmPQUuw1vy1L2ACI4zx37R3DOBdASF70/sRMMlqk vagrant@vag
The key's randomart image is:
+---[RSA 3072]----+
|        +++o o   |
|   .    .+..*    |
|  o . + O.oo.+   |
|   + + X #Eo. +  |
|    o = S % .. + |
|       . * =  =  |
|        o + .  o |
|         o       |
|                 |
+----[SHA256]-----+

```
Копируем ключ на сервер srv1 (10.14.1.3):    

```
vagrant@vag:~$ ssh-copy-id vagrant@10.14.1.3
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@10.14.1.3's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@10.14.1.3'"
and check to make sure that only the key(s) you wanted were added.

```
Заходим на сервер srv1 (10.14.1.3): 

```
vagrant@vag:~$ ssh vagrant@10.14.1.3
Welcome to srv1 (Ubuntu 20.04.2 LTS GNU/Linux )
Last login: Mon Dec 13 22:01:48 2021 from 10.14.1.2
vagrant@srv1:~$ 

```

---

#### 6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

Ответ:

```

```

---

#### 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

Ответ:

```

```

---
