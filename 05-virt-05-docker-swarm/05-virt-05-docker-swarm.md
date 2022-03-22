
## 05-virt-05-docker-swarm.
### ДЗ. "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm".
---
## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

### Ответ:
- В режиме global одна задача службы swarm выполняется на всех узлах кластера. При добавлении нового узла в кластер, создается задача, и планировщик назначает задачу этому узлу. В режиме replication можно запустить определённое (задаваемое) количество идентичных задач (копий, реплик) распредилив их по всем узлам кластера, либо на одном из улов.  
- RAFT. Протокол для реализации распределённого консенсуса. Любой из manager-узлов, в любой момент времени, может заменить leader-узел с помощью запросов и голосования, выбора лидера и соответственно, нахождения консенсунса по поводу состояния системы.
- 
---
## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
### Ответ:
```
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
u7g9ajgzy1qb2oclqqu981it8 *   node01.netology.yc   Ready     Active         Leader           20.10.13
z5fl7qwh1qqsayikdf1levv9u     node02.netology.yc   Ready     Active         Reachable        20.10.13
com9yx1l7ww71mydmexwo3dlm     node03.netology.yc   Ready     Active         Reachable        20.10.13
r96lzh4xbrtpcoisj1kljjpi8     node04.netology.yc   Ready     Active                          20.10.13
0kmm8u0y9drr1y3hrvio89973     node05.netology.yc   Ready     Active                          20.10.13
l55g5t4tlqi9ceve1qrstipsm     node06.netology.yc   Ready     Active                          20.10.13

[root@node01 ~]# docker stack ls
NAME               SERVICES   ORCHESTRATOR
swarm_monitoring   8          Swarm

```
---
## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
     
```
### Ответ:
```
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
vwtc33ba8pgh   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
azvrmrvvsm1q   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
2sl41bq2n07m   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
6yrhcdb7jthd   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
ncb2ccllc2e0   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
yan6v4k3xpgc   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
x5j6jb1hvsa9   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
woh5q6fe1ayd   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0 

[root@node01 ~]# docker stack ps swarm_monitoring
ID             NAME                                                          IMAGE                                          NODE                 DESIRED STATE   CURRENT STATE           ERROR     PORTS
yzkkkfmxqhcd   swarm_monitoring_alertmanager.1                               stefanprodan/swarmprom-alertmanager:v0.14.0    node03.netology.yc   Running         Running 4 minutes ago             
ret3o8of68z6   swarm_monitoring_caddy.1                                      stefanprodan/caddy:latest                      node01.netology.yc   Running         Running 4 minutes ago             
inay3wy7dw0r   swarm_monitoring_cadvisor.0kmm8u0y9drr1y3hrvio89973           google/cadvisor:latest                         node05.netology.yc   Running         Running 4 minutes ago             
8c4ufw3r9ec5   swarm_monitoring_cadvisor.com9yx1l7ww71mydmexwo3dlm           google/cadvisor:latest                         node03.netology.yc   Running         Running 4 minutes ago             
ilj3jjommttx   swarm_monitoring_cadvisor.l55g5t4tlqi9ceve1qrstipsm           google/cadvisor:latest                         node06.netology.yc   Running         Running 4 minutes ago             
v6evbglslp62   swarm_monitoring_cadvisor.r96lzh4xbrtpcoisj1kljjpi8           google/cadvisor:latest                         node04.netology.yc   Running         Running 4 minutes ago             
i618hj0dismv   swarm_monitoring_cadvisor.u7g9ajgzy1qb2oclqqu981it8           google/cadvisor:latest                         node01.netology.yc   Running         Running 4 minutes ago             
rmi595u8700x   swarm_monitoring_cadvisor.z5fl7qwh1qqsayikdf1levv9u           google/cadvisor:latest                         node02.netology.yc   Running         Running 4 minutes ago             
jmfnut01t6qx   swarm_monitoring_dockerd-exporter.0kmm8u0y9drr1y3hrvio89973   stefanprodan/caddy:latest                      node05.netology.yc   Running         Running 4 minutes ago             
wo0058c051r4   swarm_monitoring_dockerd-exporter.com9yx1l7ww71mydmexwo3dlm   stefanprodan/caddy:latest                      node03.netology.yc   Running         Running 4 minutes ago             
l97elo329du5   swarm_monitoring_dockerd-exporter.l55g5t4tlqi9ceve1qrstipsm   stefanprodan/caddy:latest                      node06.netology.yc   Running         Running 4 minutes ago             
srnajgt8ysfc   swarm_monitoring_dockerd-exporter.r96lzh4xbrtpcoisj1kljjpi8   stefanprodan/caddy:latest                      node04.netology.yc   Running         Running 4 minutes ago             
kfgixa997hb2   swarm_monitoring_dockerd-exporter.u7g9ajgzy1qb2oclqqu981it8   stefanprodan/caddy:latest                      node01.netology.yc   Running         Running 4 minutes ago             
u28yfq77s7jr   swarm_monitoring_dockerd-exporter.z5fl7qwh1qqsayikdf1levv9u   stefanprodan/caddy:latest                      node02.netology.yc   Running         Running 4 minutes ago             
3az90to6umtj   swarm_monitoring_grafana.1                                    stefanprodan/swarmprom-grafana:5.3.4           node01.netology.yc   Running         Running 4 minutes ago             
er2hzswhs84p   swarm_monitoring_node-exporter.0kmm8u0y9drr1y3hrvio89973      stefanprodan/swarmprom-node-exporter:v0.16.0   node05.netology.yc   Running         Running 4 minutes ago             
jjx7t8ctnhm6   swarm_monitoring_node-exporter.com9yx1l7ww71mydmexwo3dlm      stefanprodan/swarmprom-node-exporter:v0.16.0   node03.netology.yc   Running         Running 4 minutes ago             
a3akyiqlzc98   swarm_monitoring_node-exporter.l55g5t4tlqi9ceve1qrstipsm      stefanprodan/swarmprom-node-exporter:v0.16.0   node06.netology.yc   Running         Running 4 minutes ago             
zpvav9jofo37   swarm_monitoring_node-exporter.r96lzh4xbrtpcoisj1kljjpi8      stefanprodan/swarmprom-node-exporter:v0.16.0   node04.netology.yc   Running         Running 4 minutes ago             
o0vdyyyt788n   swarm_monitoring_node-exporter.u7g9ajgzy1qb2oclqqu981it8      stefanprodan/swarmprom-node-exporter:v0.16.0   node01.netology.yc   Running         Running 4 minutes ago             
846r46o7x8a7   swarm_monitoring_node-exporter.z5fl7qwh1qqsayikdf1levv9u      stefanprodan/swarmprom-node-exporter:v0.16.0   node02.netology.yc   Running         Running 4 minutes ago             
0umfvauady9q   swarm_monitoring_prometheus.1                                 stefanprodan/swarmprom-prometheus:v2.5.0       node02.netology.yc   Running         Running 4 minutes ago             
v4cns0fwdfzs   swarm_monitoring_unsee.1                                      cloudflare/unsee:v0.8.0                        node02.netology.yc   Running         Running 4 minutes ago             

```
---
