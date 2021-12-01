## Домашние задания по курсу “DEVSYS-PDC-2 DevOps-инженер”. Кожаев Л.С.
### ДЗ. 03-sysadmin-05-fs. 3.5. Файловые системы

#### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Ответ:

Нет, атрибуты файла, в частности права доступа и идентификатор владельца, являются точно такими же как и у объекта, для всех его жестких ссылок.

---
#### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

```
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end

```
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Ответ:

Машина создана, 2 диска добавлены


```
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk


```

---

#### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

Ответ:

```
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

```
---

#### 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.


Ответ:

sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc

```
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
└─sdc2                 8:34   0  511M  0 part


```

---

#### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.

Ответ:

```
$ sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part

```

___

#### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.

Ответ:


```
$ sudo mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2


vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0


```


---

#### 8. Создайте 2 независимых PV на получившихся md-устройствах.

Ответ:

```
vagrant@vagrant:~$ sudo pvcreate /dev/md0 && sudo pvcreate /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.

  vagrant@vagrant:~$ sudo pvs
  PV         VG        Fmt  Attr PSize    PFree
  /dev/md0             lvm2 ---    <2.00g   <2.00g
  /dev/md1             lvm2 ---  1018.00m 1018.00m
  /dev/sda5  vgvagrant lvm2 a--   <63.50g       0

```


---

#### 9. Создайте общую volume-group на этих двух PV.

```
vagrant@vagrant:~$ sudo vgcreate vg_md /dev/md0 /dev/md1

Volume group "vg_md" successfully created

vagrant@vagrant:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg_md       2   0   0 wz--n-  <2.99g <2.99g
  vgvagrant   1   2   0 wz--n- <63.50g     0

```

---

#### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

Ответ:

```
vagrant@vagrant:~$ sudo lvcreate -L 100Mb -n lv_md1 /dev/vg_md /dev/md1
  Logical volume "lv_md1" created.

vagrant@vagrant:~$ sudo lvdisplay /dev/vg_md/lv_md1
  --- Logical volume ---
  LV Path                /dev/vg_md/lv_md1
  LV Name                lv_md1
  VG Name                vg_md
  LV UUID                zT95Cm-QCFe-SuF2-RdkH-X4Dg-5Pm9-YLIdv2
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-12-01 10:22:25 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:2


```

---

#### 11. Создайте mkfs.ext4 ФС на получившемся LV.

Ответ:

```
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg_md/lv_md1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done


```

---

#### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

Ответ:

```
vagrant@vagrant:~$ mkdir /tmp/new && sudo mount /dev/vg_md/lv_md1 /tmp/new

vagrant@vagrant:~$ mount | grep md1
/dev/mapper/vg_md-lv_md1 on /tmp/new type ext4 (rw,relatime,stripe=256)

```

---

#### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

Ответ:

```
vagrant@vagrant:/tmp/new$ ll
total 22208
drwxr-xr-x  3 root root     4096 Dec  1 10:32 ./
drwxrwxrwt 10 root root     4096 Dec  1 10:27 ../
drwx------  2 root root    16384 Dec  1 10:26 lost+found/
-rw-r--r--  1 root root 22712441 Dec  1 08:14 test.gz


```

---


#### 14. Прикрепите вывод lsblk.

Ответ:

```

vagrant@vagrant:/tmp/new$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vg_md-lv_md1   253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vg_md-lv_md1   253:2    0  100M  0 lvm   /tmp/new


```

---

#### 15. Протестируйте целостность файла:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0

Ответ:

```
vagrant@vagrant:/tmp/new$ sudo gzip -t /tmp/new/test.gz
vagrant@vagrant:/tmp/new$ echo $?
0

```

---

#### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

Ответ:

```
vagrant@vagrant:/tmp/new$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 100.00%

```

---


#### 17. Сделайте --fail на устройство в вашем RAID1 md.

Ответ:

```
sudo mdadm --fail /dev/md0 /dev/sdc1

vagrant@vagrant:/tmp/new$ sudo mdadm -D /dev/md0 | grep fault
       1       8       33        -      faulty   /dev/sdc1


```

---

#### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.


Ответ:

```

vagrant@vagrant:/tmp/new$ dmesg |grep raid1
[  220.926625] md/raid1:md0: not clean -- starting background reconstruction
[  220.926627] md/raid1:md0: active with 2 out of 2 mirrors
[ 1739.244872] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.

```

---

#### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0

Ответ:

```
vagrant@vagrant:/tmp/new$ gzip -t test.gz
vagrant@vagrant:/tmp/new$ echo $?
0


```

---

#### 20. Погасите тестовый хост, vagrant destroy.

Ответ:

```
vagrant@vagrant:/tmp/new$ sudo poweroff

leo@l-pc:/mnt/data/vm/buntu$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...


```

---
