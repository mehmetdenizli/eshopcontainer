# Adım 30: Helm Öncesi Eksiklik Analizi ve Hazırlık Planı

Helm mimarisine geçmeden önce, mikroservislerin Kubernetes üzerinde gerçekten çalışabilmesi için gereken "kritik altyapı eksiklikleri" bu dökümanda analiz edilmiştir.

## 🔍 Tespit Edilen Eksiklikler

### 1. Container Registry (İmaj Deposu) Sorunu
- **Mevcut Durum:** Gitea kurulu ancak yerel bir Docker Registry (Harbor veya Gitea Container Registry) tam olarak Kubernetes ile entegre edilmedi.
- **Sorun:** K3s cluster'ındaki worker node'lar, `git.local` üzerindeki imajları nasıl çekeceğini bilmiyor (Auth & SSL/Insecure Issues).
- **Çözüm:** K8s üzerinde bir `regcred` (imagePullSecret) oluşturulmalı veya K3s `registries.yaml` yapılandırılmalı.

### 2. Uygulama Bağımlılıkları (Infrastructure Services)
eShopOnContainers sadece koddan ibaret değildir. Şu servislerin hazır olması gerekir:
- **SQL Server:** Veritabanları için.
- **RabbitMQ:** Servisler arası iletişim (Event Bus) için.
- **Redis:** Sepet ve Cache işlemleri için.
- **Mongo/Seq:** Loglama ve NoSQL ihtiyaçları için.
*Karar:* Bu servisleri K8s içinde Helm ile mi yoksa ayrı bir VM'de Docker Compose ile mi koşturacağız? (Öneri: K8s içinde statefulset olarak kurmak).

### 3. CI/CD Pipeline Eksikliği
- Jenkins şu an kod build edebilir ancak imajı oluşturup `git.local` registry'sine "push" yapacak pipeline adımları henüz tanımlanmadı.

## 🛠️ İzlenecek Ara Yol: "Probing" Deployment
Doğrudan Helm karmaşasına girmeden önce, düz bir `deployment.yaml` ile şunları doğrulayacağız:
1. Dışarıdan bir imajı (örneğin `nginx` veya hazır bir `eshop` imajı) registry'mize manuel pushlayıp K8s'ten çekebiliyor muyuz?
2. `git.local` adresine K8s podları erişebiliyor mu?

## 📂 Güncellenen Plan (Action Items)
1. **Gitea/Registry:** Container Registry erişimini doğrula ve `imagePullSecret` oluştur.
2. **Infrastructure:** K8s içine Postgres/MSSQL/RabbitMQ kurulumlarını başlat.
3. **Draft Deployment:** İlk servisi manuel YAML ile ayağa kaldırıp eksikleri gör.

---
**ANTIGRAVITY NOTU:** "Hızlı gitmek istiyorsan yalnız git, uzağa gitmek istiyorsan hazır git." Helm'den önce bu temelleri atmak bizi büyük YAML hatalarından kurtaracak.
