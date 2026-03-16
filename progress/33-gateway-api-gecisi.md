# Adım 33: Modern Kubernetes Gateway API Geçişi

Uygulamanın dış dünyaya açılması sürecinde, geleneksel Ingress yapısı yerine yeni nesil **Kubernetes Gateway API** kullanılmasına karar verilmiş ve başarıyla yapılandırılmıştır.

## 🎯 Neden Gateway API?
- **Modern Standart:** Ingress'in kısıtlarını aşan, daha esnek ve geleceğe dönük bir yapı sağlar.
- **Role-Based Control:** Altyapı (Gateway) ve Uygulama (Route) tanımlarının ayrıştırılmasını kolaylaştırır.
- **Traefik 3.x Desteği:** Kullandığımız Traefik 3.6.9 sürümü bu API'yi tam olarak desteklemektedir.

## 🏗️ Yapılan İşlemler

### 1. Gateway API Aktif Edilmesi
K3s üzerindeki Traefik'in Gateway API sağlayıcısını kabul etmesi için `HelmChartConfig` oluşturuldu.
- **Konfigürasyon:** `providers.kubernetesGateway.enabled: true`
- **Sonuç:** Traefik, kümedeki `Gateway` ve `HTTPRoute` kaynaklarını dinlemeye başladı.

### 2. Altyapı Tanımları
- **GatewayClass:** `traefik.io/gateway-controller` kullanılarak bir `traefik` class'ı oluşturuldu.
- **Gateway:** `eshop-gateway` adında bir listener oluşturuldu. Traefik'in K3s'teki standart `web` entrypoint'i ile eşleşmesi için `port: 8000` kullanıldı. (LoadBalancer 80 üzerinden buraya yönlendirmektedir).

### 3. Uygulama Rotaları (HTTPRoute)
Aşağıdaki domainler için rotalar tanımlandı:
- `eshop.local` -> `webapp:8080`
- `identity.local` -> `identity-api:8080`
- `catalog.local` -> `catalog-api:8080`
- `basket.local` -> `basket-api:8080`
- `ordering.local` -> `ordering-api:8080`

## ✅ Doğrulama
`kubectl get gateway` komutuyla kontrol edildiğinde:
- **Status:** `PROGRAMMED: True`
- **Attached Routes:** 5
- **Address:** `192.168.2.100` (MetalLB IP)

## ⏭️ Bir Sonraki Adım
- MacBook `/etc/hosts` dosyasına bu domainlerin eklenmesi.
- Tarayıcı üzerinden uygulamaya giriş yapılması.

---
**ANTIGRAVITY NOTU:** Ingress yerine Gateway API kullanarak projenin teknoloji seviyesini bir üst lige taşıdık. Artık çok daha esnek bir trafik yönetimimiz var.
