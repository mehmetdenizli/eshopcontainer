# Adım 31: Kubernetes Manifestleri ve Manuel Uygulama Stratejisi

Bu aşamada mikroservislerin Kubernetes'e dağıtımı için `docker-compose` mimarisi temel alınarak Kubernetes manifestleri (YAML) oluşturulmuştur.

## 🎯 Strateji
Uygulamayı önce çıplak (raw) manifestlerle ayağa kaldırarak bağımlılıkları ve Registry erişimini doğrulamak. Bu süreç, Helm mimarisine geçiş öncesi "yer denemesi" (probing) niteliğindedir.

## 🏗️ Yapılan İşlemler
1. **`manifests/` Dizini:** Proje kök dizininde `manifests/infrastructure` ve `manifests/apps` klasörleri oluşturuldu.
2. **Infrastructure:** Postgres, Redis ve RabbitMQ için Deployment ve Service tanımları hazırlandı.
3. **App Services:** Identity, Catalog, Basket, Ordering ve WebApp servisleri için manifestler oluşturuldu.
4. **Registry Entegrasyonu:** Tüm uygulama podlarına `regcred` secret desteği eklendi ve imaj yolları `git.local:3000` olarak ayarlandı.
5. **DNS & İletişim:** Servislerin birbirbirleriyle internal DNS (svc name) üzerinden konuşması sağlandı.

## ⏭️ Bir Sonraki Adım
- `regcred` secret'ının oluşturulması.
- Altyapı servislerinin (Postgres, Redis, RabbitMQ) uygulanması.
- Uygulama imajlarının MacBook üzerinden Gitea'ya pushlanması.
- Apps manifestlerinin uygulanması.

---
**ANTIGRAVITY NOTU:** Manuel manifestler, Helm'in karmaşasına girmeden önce hata ayıklama (debug) yapmamızı kolaylaştırır. Temeli sağlam atıyoruz.
