# devops-netology
## 02-git-01-vcs
### Комментарии к Terraform.gitignore
Игнорировать все файлы в каталоге .terraform где бы он не находился в репозитории (включая подкаталоги):

    # Local .terraform directories
    **/.terraform/*
---
Игнорировать все файлы c расширением .tfstate, а также файлы например .tfstate.bac,.tfstate.old и тд.:

    # .tfstate files
    *.tfstate
    *.tfstate.*
---
Игнорировать все файлы c именем crash.log находящиеся в любом каталоге:

    # Crash log files
    crash.log
---
Игнорировать все файлы c расширением .tfvars:

    # Exclude all .tfvars files, which are likely to contain sentitive data, such as
    # password, private keys, and other secrets. These should not be part of version
    # control as they are data points which are potentially sensitive and subject
    # to change depending on the environment.
    #
    *.tfvars
---
Игнорировать файлы override.tf и override.tf.json, а также файлы которые заканчиваются на _override.tf и _override.tf.json :

    # Ignore override files as they are usually used to override resources locally and so
    # are not checked in
    override.tf
    override.tf.json
    *_override.tf
    *_override.tf.json
---
Игнорировать файл terraform.rc и файлы c расширением .terraformrc  :

    # Ignore CLI configuration files
    .terraformrc
    terraform.rc
