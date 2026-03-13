# Hands-on 14: Ansible ile K3s Cluster Kurulumu

Bu rehber, hazırladığımız Ansible playbook'unu kullanarak K3s Cluster'ını (Master + Worker) nasıl kuracağınızı açıklar.

## 1. Hazırlık
Ana makinenizde (Mac) Ansible'ın yüklü olduğundan emin olun:
```bash
brew install ansible
```

## 2. Envanter Kontrolü
`ansible/inventory/hosts.ini` dosyasının doğru IP'leri içerdiğinden emin olun. Sunuculara erişimi test etmek için:
```bash
cd ansible
ansible all -m ping
```
*Not: "SUCCESS" yanıtını almalısınız.*

## 3. Playbook'u Çalıştırma
K3s Master ve Worker kurulumunu başlatan komut:
```bash
ansible-playbook playbooks/k3s-install.yml
```

Bu komut şunları yapar:
- `k3s-master` üzerinde K3s servisini başlatır.
- Kurulumdan çıkan güvenli `node-token` değerini alır.
- `k8s-worker` üzerinde K3s agent servisini başlatır ve masternode'a bağlar.

## 4. Kurulumu Doğrulama
K3s Master sunucusuna bağlanarak cluster durumunu kontrol edin:
```bash
ssh ubuntu@k3s-master "sudo kubectl get nodes"
```

Çıktıda hem `k3s-master` hem de `k8s-worker` düğümlerini "Ready" durumunda görmelisiniz.

---
**Önemli:** Eğer `/etc/hosts` dosyanızı güncellemediyseniz `ssh` ve `ansible` komutları hata verebilir. Önceki adımlardaki `hosts_to_paste.txt` içeriğini kullandığınızdan emin olun.
