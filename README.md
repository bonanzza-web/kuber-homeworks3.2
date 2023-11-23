# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------


### Ответы:

Кластер на kubeadm устанавливается почти полностью автоматически. После отрабатывания терраформа требуется запустить скрипт /home/ubuntu/[flannel.sh](https://github.com/bonanzza-web/kuber-homeworks3.2/blob/main/files/flannel.sh) для установки flannel (хотел установку flannel положить в [init.sh](https://github.com/bonanzza-web/kuber-homeworks3.2/blob/main/files/init.sh), но почему то сыпались ошибки, решил не тратить время)    

```
ubuntu@master-node:~$ ls
flannel.sh  init.output.txt  init.sh
ubuntu@master-node:~$ ./flannel.sh
namespace/kube-flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
serviceaccount/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created

```
Конфиг куба:    

```
ubuntu@master-node:~$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.2.3.31:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED

```

Скрипт [init.sh](https://github.com/bonanzza-web/kuber-homeworks3.2/blob/main/files/init.sh) создает файл init.output.txt (/home/ubuntu/init.output.txt) с командой для подключения воркер нод, мы ее копируем и вставляем на хостовой машине в плейбук join.yml, запускаем плейбук вручную    

```
bonanzza@debian:~/kuber-hw/3.2/kuber-homeworks3.2$ ansible-playbook -i inventory/hosts.txt join.yml
 ____________________________
< PLAY [Join to master node] >
 ----------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

 ________________________
< TASK [Gathering Facts] >
 ------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

ok: [worker-node-1]
ok: [worker-node-3]
ok: [worker-node-2]
ok: [worker-node-4]
 _____________
< TASK [Join] >
 -------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

changed: [worker-node-4]
changed: [worker-node-3]
changed: [worker-node-2]
changed: [worker-node-1]
 ____________
< PLAY RECAP >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

worker-node-1              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker-node-2              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker-node-3              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
worker-node-4              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

Смотрим ноды    

```
ubuntu@master-node:~$ kubectl get nodes -o wide
NAME            STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
master-node     Ready    control-plane   17m   v1.28.4   10.2.3.31     <none>        Ubuntu 20.04.6 LTS   5.4.0-166-generic   containerd://1.7.2
worker-node-1   Ready    <none>          42s   v1.28.4   10.2.3.8      <none>        Ubuntu 20.04.6 LTS   5.4.0-166-generic   containerd://1.7.2
worker-node-2   Ready    <none>          43s   v1.28.4   10.2.3.11     <none>        Ubuntu 20.04.6 LTS   5.4.0-166-generic   containerd://1.7.2
worker-node-3   Ready    <none>          44s   v1.28.4   10.2.3.5      <none>        Ubuntu 20.04.6 LTS   5.4.0-166-generic   containerd://1.7.2
worker-node-4   Ready    <none>          43s   v1.28.4   10.2.3.7      <none>        Ubuntu 20.04.6 LTS   5.4.0-166-generic   containerd://1.7.2

```
Видим, что CRI - containerd    

Проверяем, что etcd запущен на мастере:    

```
ubuntu@master-node:~$ kubectl get po -A | grep -i etcd
kube-system    etcd-master-node                      1/1     Running   0          19m

```


------


### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
