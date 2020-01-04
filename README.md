Домашнее задание 8
Добавлено: 20.12.2019 18:56
Making your first AMI with Packer
Используя кукбук из предыдущего задания, создать свою AMI:

зарегистрируйте свой аккаунт в AWS;
возьмите свои AWS Secret & API Keys, сохраните их себе в профайл 
(гуглить по запросу aws profile config file) или просто экспортите их в качестве env variables;
создайте конфигурационный файл для Packer:

builder: amazon-ebs; используйте tier t2.micro, остальные конфиги по желанию, 
в лекции есть пример, документация в вашем распоряжении;
параметризуйте конфиг с помощью секции variables и использо;
добавьте теги как к машине, на которой будет запускаться билдер, 
так и для вашей AMI; теги должны браться из пользовательских переменных,
темплейт переменных (начинаются с точки) и переменных окружения;
в секции provisioners должны быть указаны chef-solo && inspec провиженеры,
тесты у вас уже написаны в предыдущем задании. останется только найти механизм запуска их с помощью провиженера.

Работа считается выполненной по предоставлении скриншота данных о вашем AMI
(либо командой aws ec2 describe images, либо из UI-консоли AWS) и кода template_name.json на github.


Замечания по Inspec:
Применение type inspec согласно инструкции https://www.packer.io/docs/provisioners/inspec.html
приводит к ошибке
=========================
amazon-ebs: Provisioning with Inspec...
==> amazon-ebs: Executing Inspec: inspec exec /home/ubuntu/777/test/smoke/default/default_test.rb --backend ssh --host 127.0.0.1 --key-files /tmp/packer-provisioner-inspec.508558080.key --user root --port 38455 --input-file /tmp/packer-provisioner-inspec.036779615.yml
==> amazon-ebs: Provisioning step had errors: Running the cleanup provisioner, if present...
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' errored: Error executing Inspec: exec: "inspec": executable file not found in $PATH=
==========================>
Пробовал разные варианты, в том числе с лицензией
    {
      "type": "inspec",
      "profile": "https://github.com/dev-sec/linux-baseline",
      "inspec_env_vars": [ "CHEF_LICENSE=accept"]
    }
==========================>
Ошибка осталась.

Я попробовал обойти этот момент так сказать в "рукопашную"
добавил в файл сценария 
 {
            "type": "shell",
            "inline":[
                "curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec",
                "inspec --version",
                "sudo inspec exec /home/ubuntu/777/test/smoke/default/default_test.rb"
            ],
            "pause_before": "15s"
 }
 Результат работы скрипта ошибок не содержит:
  amazon-ebs: Profile: tests from /home/ubuntu/777/test/smoke/default/default_test.rb (tests from .home.ubuntu.777.test.smoke.default.default_test.rb)
    amazon-ebs: Version: (not specified)
    amazon-ebs: Target:  local://
    amazon-ebs:
    amazon-ebs:   User root
    amazon-ebs:      ↺
    amazon-ebs:   Port 80
    amazon-ebs:      ↺
    amazon-ebs:   System Package apache2
    amazon-ebs:      ✔  is expected to be installed
    amazon-ebs:   System Package mysql-server
    amazon-ebs:      ✔  is expected to be installed
    amazon-ebs:   System Package php7.2
    amazon-ebs:      ✔  is expected to be installed
    amazon-ebs:   System Package ruby
    amazon-ebs:      ✔  is expected to be installed
    amazon-ebs:   File /var/www/wp-config.php
    amazon-ebs:      ✔  is expected to exist
    amazon-ebs:   Service apache2
    amazon-ebs:      ✔  is expected to be enabled
    amazon-ebs:      ✔  is expected to be installed
    amazon-ebs:      ✔  is expected to be running
    amazon-ebs:   Port 22
    amazon-ebs:      ✔  is expected to be listening
    amazon-ebs:   Port 22
    amazon-ebs:      ✔  processes is expected to include "sshd"
    amazon-ebs:      ✔  protocols is expected to include "tcp"
    amazon-ebs:      ✔  addresses is expected to include "0.0.0.0"
    amazon-ebs:   User cthulhu01
    amazon-ebs:      ✔  is expected to exist
    amazon-ebs:   User cthulhu02
    amazon-ebs:      ✔  is expected to exist
    amazon-ebs:   User cthulhu03
    amazon-ebs:      ✔  is expected to exist
    amazon-ebs:   User cthulhu04
    amazon-ebs:      ✔  is expected to exist
    amazon-ebs:
    amazon-ebs: Test Summary: 16 successful, 0 failures, 2 skipped
==> amazon-ebs: Provisioning step had errors: Running the cleanup provisioner, if present...
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' errored: Script exited with non-zero exit status: 101.Allowed exit codes are: [0]
 
 НО!!!
 Получил ошибку
 ==> amazon-ebs: Provisioning step had errors: Running the cleanup provisioner, if present...
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' errored: Script exited with non-zero exit status: 100.Allowed exit codes are: [0]
При этом без команды:
sudo inspec exec /home/ubuntu/777/test/smoke/default/default_test.rb
Все отрабатывает без ошибок и AMIs создается.

Добавил в файл сценария код который помогает избежать ошибок при работе с Ubuntu
{
  "type": "shell",
  "inline": [
    "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
  ]
}
Не помгло....

Не могу сказать, что влияет, но вижу, что это скорей всего ошибка в создании образа.
