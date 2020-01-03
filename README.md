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
