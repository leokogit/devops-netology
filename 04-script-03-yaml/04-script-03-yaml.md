## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 04-script-03-yaml. 4.3. Языки разметки JSON и YAML

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import os
import json
import yaml

url_ip = {}
if not os.path.isfile('./url_ip.json'):
    with open('url_ip.json', 'w') as js:
        hosts = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
        json_data = json.dumps(hosts)
        js.write(json_data)
with open('url_ip.json', 'r') as js:
    # print(js.read())
    json_data = json.load(js)
    url_ip = json_data
for url in url_ip:
    resolve = socket.gethostbyname(url)
    if url_ip[url] != resolve and url_ip[url] != "0.0.0.0":
        print(f'\nIP for {url} is changed !')
        print(f'[ERROR] <{url}> IP mismatch: <{url_ip[url]}> <{resolve}>')
        url_ip[url] = resolve
    else:
        print(f'<{url}> - <{resolve}>')
        url_ip[url] = resolve
with open('url_ip.json', 'w') as js:
    json_data = json.dumps(url_ip, indent=2)
    js.write(json_data)
    print(f'\nData in url_ip.json :\n',  json_data)
with open('url_ip.yaml', 'w') as ym:
    yaml_data = yaml.dump(url_ip, explicit_start=True, explicit_end=True)
    ym.write(yaml_data)
    print(f'\nData in url_ip.yaml :\n', yaml_data)

```

### Вывод скрипта при запуске при тестировании:
```
$ python3 url_ip_yml.py
<drive.google.com> - <64.233.165.194>
<mail.google.com> - <64.233.164.19>

IP for google.com is changed !
[ERROR] <google.com> IP mismatch: <74.125.131.101> <74.125.131.113>

Data in url_ip.json :
 {
  "drive.google.com": "64.233.165.194",
  "mail.google.com": "64.233.164.19",
  "google.com": "74.125.131.113"
}

Data in url_ip.yaml :
 ---
drive.google.com: 64.233.165.194
google.com: 74.125.131.113
mail.google.com: 64.233.164.19
...

```

### json-файл(ы), который(е) записал ваш скрипт:
$ cat url_ip.json 
```json
{
  "drive.google.com": "64.233.165.194",
  "mail.google.com": "64.233.164.19",
  "google.com": "74.125.131.113"

```

### yml-файл(ы), который(е) записал ваш скрипт:
$ cat url_ip.yaml
```yaml
---
drive.google.com: 64.233.165.194
google.com: 74.125.131.113
mail.google.com: 64.233.164.19
...

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
