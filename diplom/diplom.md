# Дипломный практикум в YandexCloud
## Цели:

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.

---
## Этапы выполнения:

### 1. Регистрация доменного имени . Сделано

1. Есть доступ к личному кабинету на сайте регистратора. (Регистратор: [reg.ru](https://reg.ru))
2. Доменное имя зарегестрировано и могу им управлять (редактировать dns записи в рамках этого домена).

<p align="center"> <img src="./assets/domain.jpg"></p>
### 2. Создание инфраструктуры . Сделано

1. Создан сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами.
2. Подготовлен backend для Terraform: S3 bucket в созданном YC аккаунте.   
3. Настроены два workspace: *stage* и *prod*. (В случае выбора stage или prod меняются объём выделяемых ресурсов (cpu , memory).  
4. Создана VPC с 3 подсетями в трёх зонах доступности (ru-central1-a, ru-central1-b, ru-central1-c).
5. Команды `terraform destroy` и `terraform apply` выполняются успешно, без дополнительных ручных действий.

Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
<p align="center"> <img src="./assets/terraform_apply_stage.jpg"></p>
---
### Установка Nginx и LetsEncrypt

Необходимо разработать Ansible роль для установки Nginx и LetsEncrypt.

**Для получения LetsEncrypt сертификатов во время тестов своего кода пользуйтесь [тестовыми сертификатами](https://letsencrypt.org/docs/staging-environment/), так как количество запросов к боевым серверам LetsEncrypt [лимитировано](https://letsencrypt.org/docs/rate-limits/).**

Рекомендации:
  - Имя сервера: `you.domain`
  - Характеристики: 2vCPU, 2 RAM, External address (Public) и Internal address.

Цель:

1. Создать reverse proxy с поддержкой TLS для обеспечения безопасного доступа к веб-сервисам по HTTPS.

Ожидаемые результаты:

1. В вашей доменной зоне настроены все A-записи на внешний адрес этого сервера:
    - `https://www.you.domain` (WordPress)
    - `https://gitlab.you.domain` (Gitlab)
    - `https://grafana.you.domain` (Grafana)
    - `https://prometheus.you.domain` (Prometheus)
    - `https://alertmanager.you.domain` (Alert Manager)
2. Настроены все upstream для выше указанных URL, куда они сейчас ведут на этом шаге не важно, позже вы их отредактируете и укажите верные значения.
2. В браузере можно открыть любой из этих URL и увидеть ответ сервера (502 Bad Gateway). На текущем этапе выполнение задания это нормально!

___
