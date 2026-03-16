# Adım 13: Sunucuların Modüler Terraform ile Provision Edilmesi

Bu aşamada, tüm altyapı bileşenleri (7 sunucu) Terraform kullanılarak modüler bir yapıda ayağa kaldırılmıştır.

## Sunucu Envanteri ve Durumu
Bütün sunucular başarıyla oluşturulmuş ve IP adresleri atanmıştır:

| Hostname | IP Adresi | VM İsmi (Multipass) | Kaynaklar |
| :--- | :--- | :--- | :--- |
| **k3s-master** | 192.168.2.85 | k3s-master | 1 CPU, 2GB RAM |
| **k8s-worker** | 192.168.2.86 | k8s-worker | 2 CPU, 4GB RAM |
| **monitoring-srv** | 192.168.2.87 | monitoring-srv | 1 CPU, 2GB RAM |
| **jenkins.local** | 192.168.2.89 | jenkins-srv | 1 CPU, 3GB RAM |
| **git.local** | 192.168.2.90 | git-srv | 1 CPU, 1.5GB RAM |
| **security.local** | 192.168.2.91 | security-srv | 1 CPU, 3GB RAM |
| **vault.local** | 192.168.2.92 | vault-srv | 1 CPU, 512MB RAM |

## Teknik Uygulama Detayları
1. **Dinamik İsimlendirme:** Multipass instance isimlerinde nokta (`.`) karakteri desteklenmediği için VM isimleri `-srv` takısıyla (örn: `jenkins-srv`) kurgulanmıştır. Ancak hostname ve DNS tanımları `jenkins.local` olarak korunmuştur.
2. **Modüler Yapı:** `multipass_instance` modülü tüm sunucular için ortak `cloud-init` yapılandırmasını (SSH key, temel paketler) uygulamıştır.
3. **Hata Yönetimi:** Parallel provision sırasında Multipass limitlerine takılmamak için süreç optimize edilmiştir.

## Sonraki Adımlar
1. Ana makinede `/etc/hosts` dosyasının güncellenmesi.
2. Kubernetes (K3s) Master kurulumunun başlatılması.

**Devam edeyim mi?**

ONAY BEKLENİYOR
