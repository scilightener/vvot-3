## Как запускать
* Заполнить playbook.vars.yml.dist
* Создать и заполнить main.auto.tfvars (по мотивам variables.tf)
* terraform init
* terraform apply
* ansible-playbook --become --become-user root --become-method sudo -i inventory.ini -e @playbook.vars.yml playbook.yml
* Дождаться завершения и перейти по http://{IP}/nextcloud

Оно работает! ![telegram-cloud-photo-size-2-5314408819595538118-y](https://github.com/user-attachments/assets/d87ecdde-5986-4f2d-a29d-de5b3c20f34c)
