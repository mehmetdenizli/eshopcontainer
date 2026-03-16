# Hands-on 28: Manuel Kubernetes Manifestleri ile Dağıtım

Bu rehber, oluşturulan Kubernetes manifestlerinin cluster'a nasıl uygulanacağını açıklar.

## 📁 Manifest Dizini Yapısı
`manifests/` klasörü altındaki yapı şu şekildedir:
- `infrastructure/`: Veritabanı ve Mesaj kuyruğu gibi servisler.
- `apps/`: eShop mikroservisleri.

## 🚀 Uygulama Sırası

### 1. Altyapıyı Ayağa Kaldır
Önce veritabanı ve kuyruk servislerini başlatın:
```bash
kubectl apply -f manifests/infrastructure/
```
Podların durumunu kontrol edin:
```bash
kubectl get pods
```

### 2. Registry Secret Oluştur (Önemli)
Uygulamaları deploy etmeden önce `regcred` secret'ı mutlaka oluşturulmalıdır (Hand-on 27'de anlatıldığı gibi).

### 3. Uygulamaları Dağıt
İmajlar Gitea'ya pushlandıktan sonra uygulamaları başlatın:
```bash
kubectl apply -f manifests/apps/
```

## ⚠️ Karşılaşılan Hatalar ve Çözümleri
> **Not:** Uygulama sırasında oluşacak hatalar (CrashLoopBackOff vb.) burada dökümante edilecektir.

---
Bu aşamadan sonra her şeyin çalıştığından emin olduğumuzda, bu manifestleri Helm şablonlarına dönüştürerek ArgoCD'ye teslim edeceğiz.
