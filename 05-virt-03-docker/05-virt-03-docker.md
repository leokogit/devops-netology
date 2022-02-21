## 05-virt-03-docker.
### ДЗ. "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера".
---
## Задача 1

### Ответ:
https://hub.docker.com/r/leokodocker/nginx/tags

---
## Задача 2

### Ответ:
Сценарий:
- Высоконагруженное монолитное java веб-приложение; Т.к. требуется высокая производительность и архитектура монолитная, то физический сервер, либо аппаратная виртуализация, зависит от масштабов и используемого оборудования.  
- Nodejs веб-приложение; Можно использовать docker контейнеры, удобное быстрое управление , обновление. 
- Мобильное приложение c версиями для Android и iOS; Относительно разработки , наверное docker
- Шина данных на базе Apache Kafka; Виртуализация , зависит от того , как будут храниться данные и критичность потери информации. 
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; Я думаю тут применима гибридная схема виртуализация и контейнеры.  
- Мониторинг-стек на базе Prometheus и Grafana; Можно использовать контейнеры : скорость развертывания, возможность масштабирования для различных задач
- MongoDB, как основное хранилище данных для java-приложения; Аппаратная виртуализация, схд
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry. Виртуализация, СХД

---
## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ:

- Запускаем 1-й контейнера и подключаем ```/data``` 
```bash
docker run -d -v /opt/docker/data:/data -it centos bash
```
- Запуск 2-го контейнера и также подключаем ```/data``` 
```bash
docker run -d -v /opt/docker/data:/data -it debian bash
```
```
# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
4f8f75863316   debian    "bash"    2 minutes ago   Up 2 minutes             unruffled_williamson
6085050b45d3   centos    "bash"    6 minutes ago   Up 6 minutes             gifted_panini
```
- Подключаемся к первому контейнеру и создаём текстовый файл в ```/data```
```bash
# docker exec -it 6085050b45d3 bash

[root@6085050b45d3 data]# echo test1_centos > text1.txt
[root@6085050b45d3 data]# ls
text1.txt

```
- Добавляем еще один файл на хостовой машине в ```/data```
```bash
# echo onemoretext > text2.txt
# ls
text1.txt  text2.txt

```
- Подключаемся к второму контейнеру и отображаем листинг файлов в ```/data``` контейнера. 
```bash
# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
4f8f75863316   debian    "bash"    2 minutes ago   Up 2 minutes             unruffled_williamson
6085050b45d3   centos    "bash"    6 minutes ago   Up 6 minutes             gifted_panini

# docker exec -it 4f8f75863316 bash
root@4f8f75863316:/# cd /data/
root@4f8f75863316:/data# ls -la
total 16
drwxr-xr-x 2 root root 4096 Feb 21 20:34 .
drwxr-xr-x 1 root root 4096 Feb 21 20:25 ..
-rw-r--r-- 1 root root   13 Feb 21 20:31 text1.txt
-rw-r--r-- 1 root root   12 Feb 21 20:34 text2.txt

```
---
