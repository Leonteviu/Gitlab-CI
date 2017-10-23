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
