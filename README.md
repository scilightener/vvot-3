## Как запускать
* Заполнить playbook.vars.yml.dist
* Создать и заполнить main.auto.tfvars (по мотивам variables.tf)
* terraform init
* terraform apply
* ansible-playbook --become --become-user root --become-method sudo -i inventory.ini -e @playbook.vars.yml playbook.yml
* Дождаться завершения и перейти по http://{IP}/nextcloud
