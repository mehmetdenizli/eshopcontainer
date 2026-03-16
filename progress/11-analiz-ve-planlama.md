# Adım 01: Analiz, Temizlik ve Kaynak Planlaması

Bu aşamada mevcut proje yapısı incelenmiş, eski altyapı dosyaları temizlenmiş ve yeni DevOps mimarisi için kaynak planlaması yapılmıştır.

## Yapılan Analizler

### 1. Uygulama Yapısı
- Mevcut `docker-compose.yml` dosyası, eShopOnContainers'ın temel mikroservislerini (Identity, Catalog, Basket, Ordering, WebApp) ve bağımlılıklarını (PostgreSQL, Redis, RabbitMQ) içermektedir.
- .NET Aspire ve geleneksel Docker yaklaşımlarının hibrit bir şekilde kullanıldığı görülmüştür.

### 2. Temizlik Operasyonu
- Hatalı veya eski olan `progress/11-kubernetes-infrastructure.md` dosyası silindi.
- `terraform/` dizini altındaki eski yapılandırmalar, modüler yapıya hazırlık amacıyla temizlendi.

## Kaynak Dağılım Planı (24GB RAM / 10 CPU / 100GB Disk)

Ana makinenin (Host OS) stabil çalışabilmesi için toplam kaynakların yaklaşık %75-80'i VM'lere ayrılmıştır:

| Sunucu Adı | Rol | CPU | RAM | Disk |
| :--- | :--- | :--- | :--- | :--- |
| **k3s-master** | K8s Control Plane | 1 | 2GB | 10GB |
| **k8s-worker** | eShop Podları | 2 | 4GB | 25GB |
| **jenkins.local** | CI/CD Süreçleri | 1 | 3GB | 15GB |
| **monitoring-srv**| Log & Metrics | 1 | 2GB | 15GB |
| **security.local** | Güvenlik (Sonar) | 1 | 3GB | 10GB |
| **git.local** | Git & Registry | 1 | 1.5GB | 15GB |
| **vault.local** | Secret Management | 1 | 512MB | 5GB |
| **TOPLAM (VM)** | | **8** | **16GB** | **95GB** |
| **BOŞTA (HOST)** | | **2** | **8GB** | **5GB** |

## Sonraki Adımlar
1. `terraform/modules/` altında Multipass sağlayıcısı ile uyumlu modüler yapının kurulması.
2. `k3s-master` sunucusunun provision edilmesi.

**Devam edeyim mi?**

ONAY BEKLENİYOR
