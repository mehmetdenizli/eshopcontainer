# Hands-on 15: K3s Cluster Doğrulama ve Final Konfigürasyon

K3s cluster kurulumu hatasız bir şekilde tamamlanmıştır. Bu doküman, kurulumun başarılı olduğunu doğrulamak için kullanılan komutları ve cluster'ın final durumunu içerir.

## 1. Playbook Çalıştırma Özeti
Kurulum, `ansible-playbook playbooks/k3s-install.yml` komutu ile gerçekleştirilmiştir. Final recap çıktımız:

```text
PLAY RECAP *********************************************************************
k3s-master                 : ok=4    changed=1    unreachable=0    failed=0    skipped=2
k8s-worker                 : ok=3    changed=1    unreachable=0    failed=0    skipped=3
```

## 2. Cluster Düğüm Durumları
Kurulum sonrası master node üzerinden alınan canlı durum çıktısı:

```bash
# Komut:
ssh ubuntu@k3s-master "sudo kubectl get nodes"

# Çıktı:
NAME         STATUS   ROLES           AGE     VERSION
k3s-master   Ready    control-plane   5m12s   v1.34.5+k3s1
k8s-worker   Ready    <none>          2m04s   v1.34.5+k3s1
```

## 3. Kullanılan Kritik Yapılandırmalar

### Ansible Envanteri (`ansible/inventory/hosts.ini`)
Cluster için kullanılan güncel IP'ler ve gruplandırma:
```ini
[k3s_master]
k3s-master ansible_host=192.168.2.85

[k3s_worker]
k8s-worker ansible_host=192.168.2.86

[k3s_cluster:children]
k3s_master
k3s_worker
```

### K3s Kurulum Playbook'u (`ansible/playbooks/k3s-install.yml`)
Hatasız kurulumu sağlayan otomasyon kodu:
```yaml
- name: K3s Cluster Kurulumu
  hosts: k3s_cluster
  become: true
  tasks:
    - name: K3s Master Servisini Kur
      shell: curl -sfL https://get.k3s.io | sh -
      when: "'k3s_master' in group_names"
    
    - name: K3s Token'ı Oku
      slurp: src=/var/lib/rancher/k3s/server/node-token
      register: node_token
      when: "'k3s_master' in group_names"

    - name: K3s Worker Kur ve Bağla
      shell: "curl -sfL https://get.k3s.io | K3S_URL=https://{{ hostvars['k3s-master']['ansible_host'] }}:6443 K3S_TOKEN={{ hostvars['k3s-master']['node_token'].content | b64decode | trim }} sh -"
      when: "'k3s_worker' in group_names"
```

## 4. Sorunsuz Erişim Testi
Tüm sunucuların (7 adet) Ansible üzerinden erişilebilirliği şu komutla tescillenmiştir:
```bash
ansible all -m ping
# Sonuç: Hepsi SUCCESS (pong)
```

Bu aşamada cluster, eShopOnContainers servislerini kabul etmeye tamamen hazırdır.
