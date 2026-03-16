# Hands-on 18: Tüm Sunucularda Docker ve Docker Compose Yönetimi

Bu rehber, Ansible ile kurduğumuz Docker altyapısının nasıl kontrol edileceğini ve temel yönetim komutlarını açıklar.

## 1. Kurulumu Doğrulama

Herhangi bir sunucumuza bağlanarak Docker durumunu kontrol edebilirsiniz:
```bash
ssh ubuntu@git.local "docker version"
```

Tüm sunucularda Docker'ın çalışıp çalışmadığını topluca test etmek için:
```bash
cd ansible
ansible all -a "docker info" | grep -i "Server Version"
```

## 2. Docker Compose (V2) Kullanımı
Yeni nesil Docker Compose, `docker-compose` komutu yerine `docker compose` (boşluklu) olarak kullanılır.

Versiyon kontrolü:
```bash
docker compose version
```

## 3. İzinler Hakkında
Ansible playbook'umuz `ubuntu` kullanıcısını `docker` grubuna eklemiştir. **Ancak**, bu değişikliğin terminalde aktif olması için SSH oturumunun kapatılıp tekrar açılması (veya `newgrp docker` komutu) gerekir. 

Test etmek için:
```bash
docker ps
```
*Hata alıyorsanız (Permission Denied), oturumu kapatıp yeniden bağlanın.*

## 4. Playbook'u Yeniden Çalıştırma
Eğer yeni bir sunucu eklerseniz, Docker kurmak için sadece şu komutu çalıştırmanız yeterlidir:
```bash
ansible-playbook playbooks/docker-setup.yml
```

---
Bu altyapıyla artık tüm DevOps araçlarımızı konteynerize (containerized) bir şekilde güvenle çalıştırabiliriz.
