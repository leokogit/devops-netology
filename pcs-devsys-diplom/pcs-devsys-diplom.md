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
---

## Процесс установки и выпуска сертификата с помощью hashicorp vault

### Подготовка среды
Скачиваем deb пакет (ставим на Ubuntu) и устанавливаем vault:
```bash

$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

$ sudo apt-get update && sudo apt-get install vault

```
Устанавливаем утилиту jq для работы с JSON (jq tool to parse JSON output):

```bash
$ sudo apt-get install jq
```
### Запуск vault

Запускаем vault в dev режиме в отдельном терминале:

```bash
$ vault server -dev -dev-root-token-id root

==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.17.5
              Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
               Log Level: info
                   Mlock: supported: true, enabled: false
           Recovery Mode: false
                 Storage: inmem
                 Version: Vault v1.9.2
             Version Sha: f4c6d873e2767c0d6853b5d9ffc77b0d297bfbdf

==> Vault server started! Log data will stream in below:

2022-01-19T15:28:27.759+0300 [INFO]  proxy environment: http_proxy="\"\"" https_proxy="\"\"" no_proxy="\"\""
2022-01-19T15:28:27.759+0300 [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possible, but this value should be manually set
2022-01-19T15:28:27.764+0300 [INFO]  core: Initializing VersionTimestamps for core
2022-01-19T15:28:27.773+0300 [INFO]  core: security barrier not initialized
2022-01-19T15:28:27.773+0300 [INFO]  core: security barrier initialized: stored=1 shares=1 threshold=1
2022-01-19T15:28:27.774+0300 [INFO]  core: post-unseal setup starting
2022-01-19T15:28:27.778+0300 [INFO]  core: loaded wrapping token key
2022-01-19T15:28:27.778+0300 [INFO]  core: Recorded vault version: vault version=1.9.2 upgrade time="2022-01-19 15:28:27.778810938 +0300 MSK m=+0.744645071"
2022-01-19T15:28:27.780+0300 [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-19T15:28:27.780+0300 [INFO]  core: no mounts; adding default mount table
2022-01-19T15:28:27.795+0300 [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-19T15:28:27.799+0300 [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-19T15:28:27.803+0300 [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-19T15:28:27.808+0300 [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-19T15:28:27.809+0300 [INFO]  rollback: starting rollback manager
2022-01-19T15:28:27.810+0300 [INFO]  core: restoring leases
2022-01-19T15:28:27.812+0300 [INFO]  identity: entities restored
2022-01-19T15:28:27.812+0300 [INFO]  identity: groups restored
2022-01-19T15:28:27.812+0300 [INFO]  core: post-unseal setup complete
2022-01-19T15:28:27.813+0300 [INFO]  core: root token generated
2022-01-19T15:28:27.813+0300 [INFO]  core: pre-seal teardown starting
2022-01-19T15:28:27.814+0300 [INFO]  expiration: lease restore complete
2022-01-19T15:28:27.823+0300 [INFO]  rollback: stopping rollback manager
2022-01-19T15:28:27.824+0300 [INFO]  core: pre-seal teardown complete
2022-01-19T15:28:27.824+0300 [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
2022-01-19T15:28:27.824+0300 [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
2022-01-19T15:28:27.825+0300 [INFO]  core: post-unseal setup starting
2022-01-19T15:28:27.826+0300 [INFO]  core: loaded wrapping token key
2022-01-19T15:28:27.826+0300 [INFO]  core: successfully setup plugin catalog: plugin-directory="\"\""
2022-01-19T15:28:27.827+0300 [INFO]  core: successfully mounted backend: type=system path=sys/
2022-01-19T15:28:27.827+0300 [INFO]  core: successfully mounted backend: type=identity path=identity/
2022-01-19T15:28:27.827+0300 [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
2022-01-19T15:28:27.832+0300 [INFO]  core: successfully enabled credential backend: type=token path=token/
2022-01-19T15:28:27.832+0300 [INFO]  rollback: starting rollback manager
2022-01-19T15:28:27.834+0300 [INFO]  core: restoring leases
2022-01-19T15:28:27.834+0300 [INFO]  expiration: lease restore complete
2022-01-19T15:28:27.834+0300 [INFO]  identity: entities restored
2022-01-19T15:28:27.834+0300 [INFO]  identity: groups restored
2022-01-19T15:28:27.834+0300 [INFO]  core: post-unseal setup complete
2022-01-19T15:28:27.834+0300 [INFO]  core: vault is unsealed
2022-01-19T15:28:27.839+0300 [INFO]  expiration: revoked lease: lease_id=auth/token/root/h0a257764c4cd2234794bc2154a20f2428ad2bc247cce8a5717238b7ec0467aa1
2022-01-19T15:28:27.850+0300 [INFO]  core: successful mount: namespace="\"\"" path=secret/ type=kv
2022-01-19T15:28:27.861+0300 [INFO]  secrets.kv.kv_3a6f0e19: collecting keys to upgrade
2022-01-19T15:28:27.861+0300 [INFO]  secrets.kv.kv_3a6f0e19: done collecting keys: num_keys=1
2022-01-19T15:28:27.861+0300 [INFO]  secrets.kv.kv_3a6f0e19: upgrading keys finished
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: aXAcihSV/u7UF2VEahby00LpsKLskoHCAfChFQrk/gw=
Root Token: root

Development mode should NOT be used in production installations!
```
В другом теримнале продолжаем работу :   
Проверяем что сервер запущен в dev режиме

```bash
$ tty
/dev/pts/1

$ ps -aux | grep vault
websrv1     1455  0.6  2.6 842992 90848 pts/0    Sl+  15:28   0:02 vault server -dev -dev-root-token-id root

$ sudo lsof -i:8200
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
vault   1455 websrv1    8u  IPv4  28797      0t0  TCP localhost:8200 (LISTEN)
```
Экспортируем переменную окружения vault CLI, для обращения к серверу Vault.

```bash
$ export VAULT_ADDR=http://127.0.0.1:8200

$ echo $VAULT_ADDR
http://127.0.0.1:8200
```
Экспортируем переменную окружения vault CLI, для аутентификации на сервере Vault.

```bash
$ export VAULT_TOKEN=root

$ echo $VAULT_TOKEN
root
```
### Шаг 1: Создание корневого ЦС

1. Включаем секреты pki размещаемые в pki/.

```bash
$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
```
2. Настраиваем механизм секретов в pki/ на выдачу сертификатов с максимальным временем жизни (TTL) 87600 часов

```bash
$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
```
3. Генерируем корневой сертификат и сохраняем его в файле CA_cert.crt.

```bash
$ vault write -field=certificate pki/root/generate/internal \
     common_name="example.com" \
     ttl=87600h > CA_cert.crt
```
4. Настраиваем CA and CRL URLs.

```bash
$ vault write pki/config/urls \
     issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
     crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
```


### Шаг 2: Создание промежуточного ЦС

1. Включаем секреты pki размещаемые в pki_int/

```bash
$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
```
2. Настраиваем механизм секретов в pki_int/ на выдачу сертификатов с максимальным временем жизни (TTL) 43800 часов.

```bash
$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
```
3. Генерируем промежуточный сертификат и сохраняем CSR в pki_intermediate.csr.

```bash
vault write -format=json pki_int/intermediate/generate/internal \
     common_name="example.com Intermediate Authority" \
     | jq -r '.data.csr' > pki_intermediate.csr
```
4. Подписываем промежуточный сертификат закрытым ключом корневого ЦС и сохраняем созданный сертификат в intermediate.cert.pem.

```bash
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem
```
5. После того, как CSR подписан и корневой ЦС возвращает сертификат, его можно импортировать обратно в Vault.

```bash
$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
### Шаг 3: Создаем роль

Создаем роль с именем example-dot-com, которая разрешает поддомены.

```bash
$ vault write pki_int/roles/example-dot-com \
>      allowed_domains="example.com" \
>      allow_subdomains=true \
>      max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
```

### Шаг 4: Запрос сертификатов

1. Запрашиваем новый сертификат для домена test.example.com на основе роли example-dot-com.

```bash
$ vault write -format=json pki_int/issue/example-dot-com common_name="test.example.com" ttl="720h" > ~/issue.crt
```
2. Извлекаем из JSON файла issue.crt данные по сертфикату и ключу и записываем в отдельные файлы: 

```bash
cat ~/issue.crt | jq -r .data.certificate > ~/test.example.crt.pem
cat ~/issue.crt | jq -r .data.issuing_ca >> ~/test.example.crt.pem
cat ~/issue.crt | jq -r .data.private_key > ~/test.example.key
```
---

## Процесс установки и настройки сервера nginx

Установка:
```bash
$ sudo apt install nginx
```
Настройка кофигурации (/etc/nginx/nginx.conf) :

```nginx



```
sudo mkdir -p /var/www/test.example.com/html
websrv1@websrv1:~$ ll /var/www/test.example.com/html
total 8
drwxr-xr-x 2 root root 4096 Jan 19 18:21 ./
drwxr-xr-x 3 root root 4096 Jan 19 18:21 ../
websrv1@websrv1:~$ sudo chown -R $USER:$USER /var/www/test.example.com/html
websrv1@websrv1:~$ ll /var/www/test.example.com/html
total 8
drwxr-xr-x 2 websrv1 websrv1 4096 Jan 19 18:21 ./
drwxr-xr-x 3 root    root    4096 Jan 19 18:21 ../
websrv1@websrv1:~$ cd /var/www/test.example.com/html
websrv1@websrv1:/var/www/test.example.com/html$ sudo chmod -R 755 /var/www/test.example.com/html
websrv1@websrv1:/var/www/test.example.com/html$ ll
total 8
drwxr-xr-x 2 websrv1 websrv1 4096 Jan 19 18:21 ./
drwxr-xr-x 3 root    root    4096 Jan 19 18:21 ../
websrv1@websrv1:/var/www/test.example.com/html$ echo "Success! SSL is working!" > /var/www/test.example.com/html/index.html
websrv1@websrv1:/var/www/test.example.com/html$ cat /var/www/test.example.com/html/index.html
Success! SSL is working!
websrv1@websrv1:/var/www/test.example.com/html$ sudo vim /etc/nginx/sites-available/test.example.com


$ sudo vim /etc/nginx/sites-available/test.example.com
$ sudo ln -s /etc/nginx/sites-available/test.example.com /etc/nginx/sites-enabled/
sudo systemctl restart nginx
openssl s_client -connect 127.0.0.1:443


## Страница сервера nginx в браузере хоста не содержит предупреждений

Cкриншот:

![stack](/pcs-devsys-diplom//crt.jpg "test.example.com")


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
