## 06-db-05-elasticsearch.
### ДЗ. "6.5. Elasticsearch".

## Задача 1

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
### Ответ:
#### Dockerfile 
```
~/netology/06-db-05-elasticsearch$ cat Dockerfile 

FROM centos:7
LABEL Netology 6.5:Elasticsearch
MAINTAINER leokodocker

RUN yum upgrade -y
RUN yum install wget -y
RUN yum install perl-Digest-SHA -y
RUN yum install java-11-openjdk -y

#RUN  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.3-linux-x86_64.tar.gz \
#    &&  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.3-linux-x86_64.tar.gz.sha512
COPY elasticsearch-7.17.3-linux-x86_64.tar.gz /.
COPY elasticsearch-7.17.3-linux-x86_64.tar.gz.sha512 /.
RUN shasum -a 512 -c elasticsearch-7.17.3-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-7.17.3-linux-x86_64.tar.gz \
    && rm -f elasticsearch-7.17.3-linux-x86_64.tar.gz \
    && mv /elasticsearch-7.17.3 /elasticsearch
# copy the configuration file into the container
COPY elasticsearch.yml /elasticsearch/config/
RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
ENV ES_JAVA_HOME=/usr/
#WORKDIR /data
RUN mkdir /var/lib/logs /var/lib/data /elasticsearch/snapshots

RUN chown -R elasticsearch:elasticsearch /elasticsearch && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/data

USER elasticsearch
CMD ["/elasticsearch/bin/elasticsearch"]

```
#### Cсылкa на образ в репозитории dockerhub
https://hub.docker.com/r/leokodocker/es
#### Ответ `elasticsearch` на запрос пути `/` в json виде
```
{
  "name" : "netology_test",
  "cluster_name" : "netology_es",
  "cluster_uuid" : "SyOU-_VDRcKNhvMrsW8J0Q",
  "version" : {
    "number" : "7.17.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "5ad023604c8d7416c9eb6c0eadb62b14e766caff",
    "build_date" : "2022-04-19T08:11:19.070913226Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
---
## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ:
#### Добавление индексов
```
$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```
#### Получите список индексов и их статусов
```
$ curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases NllpwcV9RaCtcxtckSFB-A   1   0         40            0     37.9mb         37.9mb
green  open   ind-1            -cn-aaNaTXWtQojZE_Mvmg   1   0          0            0       226b           226b
yellow open   ind-3            VQ4oNCzNRnGi4NNpbkg_Fw   4   2          0            0       904b           904b
yellow open   ind-2            NChCk76yRPGP13RI84HfpA   2   1          0            0       452b           452b

$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_es",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_es",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
#### Получите состояние кластера `elasticsearch`
```
$ curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_es",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
#### Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
У нас один хост в кластере (ES также сконфигурирован в single-node), одна нода. ind-2 и ind-3 создавались с репликами, но у нас нет достаточного количества хостов для репликации.   
#### Удалите все индексы
```
$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```
---
## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы $ curl -X GET 'http://localhost:9200/_cat/indices?v' 
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases NllpwcV9RaCtcxtckSFB-A   1   0         40            0     37.9mb         37.9mb
green  open   test-2           jSi_wlMnSlyVrALjmorX2g   1   0          0            0       226b           226b
из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
Рtc
### Ответ:
#### Регистрация `snapshot repository` c именем `netology_backup`
```
[elasticsearch@elastic /]$ ll /elasticsearch/snapshots/
total 0
```
```
$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch/snapshots"
  }
}
'
```
Вывод в консоли:
```
{
  "acknowledged" : true
}
```
```
$ curl -X GET "localhost:9200/_snapshot/netology_backup?pretty"
```
Вывод в консоли:
```
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch/snapshots"
    }
  }
}
```
#### Создание индекса `test` с 0 реплик и 1 шардом и вывод списка индексов
```
$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
```
Вывод в консоли:
```
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```
```
$ curl -X GET 'http://localhost:9200/_cat/indices?v' 
```
Вывод в консоли:
```
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases NllpwcV9RaCtcxtckSFB-A   1   0         40            0     37.9mb         37.9mb
green  open   test             G7CMtHVbQvi8tt6yKtnDcA   1   0          0            0       226b           226b
```
#### Создание `snapshot` состояния кластера `elasticsearch`
```
$ curl -X PUT "localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true&pretty"
```
Вывод в консоли:
```
{
  "snapshot" : {
    "snapshot" : "elasticsearch",
    "uuid" : "-NwzbdZvQJOHlKsDgcHn-Q",
    "repository" : "netology_backup",
    "version_id" : 7170399,
    "version" : "7.17.3",
    "indices" : [
      "test",
      ".geoip_databases",
      ".ds-.logs-deprecation.elasticsearch-default-2022.04.25-000001",
      ".ds-ilm-history-5-2022.04.25-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-04-26T11:57:53.419Z",
    "start_time_in_millis" : 1650974273419,
    "end_time" : "2022-04-26T11:57:54.620Z",
    "end_time_in_millis" : 1650974274620,
    "duration_in_millis" : 1201,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```
#### Cписок файлов в директории со `snapshot`ами
```
$ ll /elasticsearch/snapshots/

total 48
-rw-r--r-- 1 elasticsearch elasticsearch  1425 Apr 26 11:57 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Apr 26 11:57 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Apr 26 11:57 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29284 Apr 26 11:57 meta--NwzbdZvQJOHlKsDgcHn-Q.dat
-rw-r--r-- 1 elasticsearch elasticsearch   712 Apr 26 11:57 snap--NwzbdZvQJOHlKsDgcHn-Q.dat
```
#### Удаление индекса `test` и создание индекса `test-2`. список индексов
```
$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}

$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

$ curl -X GET 'http://localhost:9200/_cat/indices?v' 

health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases NllpwcV9RaCtcxtckSFB-A   1   0         40            0     37.9mb         37.9mb
green  open   test-2           jSi_wlMnSlyVrALjmorX2g   1   0          0            0       226b           226b
```
#### Восстановление состояния кластера `elasticsearch` из `snapshot`, созданного ранее. Запрос к API восстановления и итоговый список индексов
```
$ curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test",
  "include_global_state": true
}
'
{
  "accepted" : true
}
$ curl -X GET 'http://localhost:9200/_cat/indices?v'

health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases jKhBDuKlRbqSgtHMKBDvJQ   1   0         55           10     66.9mb         66.9mb
green  open   test-2           jSi_wlMnSlyVrALjmorX2g   1   0          0            0       226b           226b
green  open   test             nxW49Kk6SOqAAMc3Ho6UBg   1   0          0            0       226b           226b
```
---
