# Adım 18: Tüm Sunuculara Docker ve Docker Compose Kurulumu

Bu aşamada, ilerleyen adımlarda kurulacak olan DevOps araçlarının (Gitea, Jenkins, Registry, vb.) altyapısını oluşturmak amacıyla tüm sanal makinelerimize Docker Engine ve Docker Compose Plugin kurulumu yapılmıştır.

## Teknik Detaylar
1. **Otomasyon (Ansible):** `docker-setup.yml` playbook'u ile tüm sunuculara (7 adet) eşzamanlı kurulum yapıldı.
2. **Mimar Uyumluluğu:** Apple Silicon (M1/M2/M3) üzerinde çalışan sanal makineler için `arm64` Docker repository'si otomatik olarak yapılandırıldı.
3. **Docker Compose:** Modern `docker-compose-plugin` (V2) sisteme entegre edildi.
4. **Kullanıcı Yetkileri:** `ubuntu` kullanıcısı `docker` grubuna eklendi (Sudo gerekmeden docker komutlarını çalıştırabilmek için).
5. **Ansible Uyumluluğu:** Gelecek adımlarda Ansible'ın konteynerleri yönetebilmesi için `python3-docker` SDK'sı kuruldu.

## Kurulum Durumu (Doğrulama)
Tüm sunucularda Docker servisleri başarıyla ayağa kalktı:

| Sunucu | Docker Versiyonu | Durum |
| :--- | :--- | :--- |
| **k3s-master** | 29.3.0 | Aktif |
| **k8s-worker** | 29.3.0 | Aktif |
| **jenkins-srv** | 29.3.0 | Aktif |
| **monitoring-srv** | 29.3.0 | Aktif |
| **security-srv** | 29.3.0 | Aktif |
| **git-srv** | 29.3.0 | Aktif |
| **vault-srv** | 29.3.0 | Aktif |

## Sonraki Adımlar
1. **Gitea Kurulumu:** `git-srv` üzerinde Docker Compose ile Git Sunucusu kurulumu.
2. **Docker Registry:** Yerel imajlarımızı saklayacağımız Registry kurulumu.

**Devam edeyim mi?**

ONAY BEKLENİYOR
