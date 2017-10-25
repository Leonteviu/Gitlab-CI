# **Пример создания инстанса, на котором потом будет поднят Gitlab-CI**

========================================================================

# Homework 19 (branch homework-19)

## Создание инстанса несколькими способами:

### 1\. Cоздадим инстанс и правила firewall для http и https с использованием gcloud:

- gcloud compute instances create --boot-disk-size=100GB --image=$(gcloud compute images list --filter ubuntu-1604-lts --uri) --image-project=ci-cd-183409 --machine-type=n1-standard-1 --restart-on-failure --zone=europe-west1-b --tags http-server,https-server virtual-ci

- gcloud compute --project=ci-cd-183409 firewall-rules create default-allow-http --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

- gcloud compute --project=ci-cd-183409 firewall-rules create default-allow-https --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

## Создание инстанса и установка на него docker-ce и docker-compose, используя Terraform и Ansible:

- Для создания виртуальной машины:

  - $ cd ~/CI-CD/terraform
  - $ terraform apply

- Установить docker-ce и docker-compose:

  - В ~/CI-CD/ansible/docker_install.yml установить значение **vm_external_ip:** и **hosts:**
  - $ cd ~/CI-CD/ansible
  - $ ansible-playbook docker_install.yml

    > В шаблоне ~/CI-CD/ansible/templates/docker-compose.yml.j2 происходит установка **Gitlab-CE**, а также создание **gitlab-runner**

### 2\. Создание инстанса с использованием docker-machine

- $ docker-machine create --driver google --google-project ci-cd-183409 --google-zone europe-west1-b --google-machine-type n1-standard-1 --google-disk-size "100" --google-tags "http-server","https-server" --google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) gitlab-ci<br>

> Не забудем создать правила для Firewall:

- gcloud compute --project=ci-cd-183409 firewall-rules create default-allow-http --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
- gcloud compute --project=ci-cd-183409 firewall-rules create default-allow-https --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

- $ eval $(docker-machine env gitlab-ci)

# Homework-20

> Создали новый пайплайн .gitlab-ci-yml, переименовав пайплайн домашнего задания 19 в .gitlab-ci.yml.HW-19

## Dev-окружение

Изменим пайплайн таким образом, чтобы job deploy стал определением окружения dev, на которое условно будет выкатываться каждое изменение в коде проекта:

> environment:<br>
> name: dev<br>
> url: <http://dev.example.com>

## Staging и Production

Если на dev мы можем выкатывать последнюю версию кода, то к production окружению это может быть неприменимо, если, конечно, вы не стремитесь к continuous deployment.<br>

Определим два новых этапа: **stage** и **production**, первый будет содержать job имитирующий выкатку на staging окружение, второй - на production окружение.<br>

Определим эти job таким образом, чтобы они запускались с кнопки:

> **when: manual** – говорит о том, что job должен быть запущен человеком из UI.

## Условия и ограничения

Обычно, на production окружение выводится приложение с явно зафиксированной версией (например, 2.4.10).<br>
Добавим в описание pipeline директиву, которая не позволит нам выкатить на staging и production код, не помеченный с помощью тэга в git.

> Директива **only** описывает список условий, которые должны быть истинны, чтобы job мог запуститься.<br>
> Регулярное выражение `- /^\d+.\d+.\d+/` означает, что должен стоять semver тэг в git, например, 2.4.10

Изменение, помеченное тэгом в git запустит полный пайплайн:

- $ git commit -a -m '#4 add logout button to profile page'
- $ git tag 2.4.10
- $ git push --tags

## Динамические окружения

Gitlab CI позволяет определить динамические окружения, это мощная функциональность позволяет вам иметь выделенный стенд для, например, каждой feature-ветки в git.<br>
Определяются динамические окружения с помощью переменных, доступных в .gitlab-ci.yml (например, $CI_COMMIT_REF_NAME и $CI_ENVIRONMENT_SLUG)

Job **branch review:** определяет динамическое окружение для каждой ветки в репозитории, кроме ветки master
