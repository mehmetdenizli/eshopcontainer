# Hands-on 28: Manuel Kubernetes Manifestleri ile Dağıtım

Bu rehber, eShopOnContainers projesinin Kubernetes (K3s) üzerine manuel manifest (YAML) dosyalarıyla nasıl dağıtıldığını açıklar.

## 📁 1. Manifestlerin Hazırlanması ve Sunucuya Senkronizasyonu
Local makinedeki (Macbook) `manifests/` dizini, Ansible kullanılarak K3s Master node'una (`/home/ubuntu/manifests/`) kopyalanmıştır.

```bash
# Macbook üzerinden senkronizasyon:
ansible k3s_master -i ansible/inventory/hosts.ini -m file -a "path=/home/ubuntu/manifests state=directory" --become
ansible k3s_master -i ansible/inventory/hosts.ini -m copy -a "src=manifests/ dest=/home/ubuntu/manifests/" --become
```

## 🚀 2. Uygulama Sırası

### Adım 1: Altyapıyı Ayağa Kaldır (Infrastructure)
Önce veritabanı ve kuyruk servislerini başlatın:
```bash
kubectl apply -f /home/ubuntu/manifests/infrastructure/
```

### Adım 2: Registry Secret Oluştur (regcred)
Uygulamaları deploy etmeden önce `regcred` secret'ı mutlaka oluşturulmalıdır (Hands-on 27'de detaylandırılmıştır).

### Adım 3: Uygulamaları Dağıt (Apps)
İmajlar Gitea'ya pushlandıktan sonra uygulamaları başlatın:
```bash
kubectl apply -f /home/ubuntu/manifests/apps/
```

## 🔍 3. Doğrulama, Hatalar ve Çözümleri

### Pod Durumlarını İzleme:
```bash
kubectl get pods -w
```

### ImagePullBackOff / ErrImagePull:
Eğer imaj pushlanmadan önce deployment yapıldıysa veya imaj bulunamadıysa bu hatayı alırsınız. İmaj pushlandıktan sonra ilgili podu silerek yeniden oluşmasını tetikleyin:
```bash
kubectl delete pod <pod-adi>
```

### Pod Detaylarını İnceleme:
```bash
kubectl describe pod <pod-adi>
```

## 📜 4. Kaydedilen Önemli Kararlar
- **Resource Limits:** Tüm podlara CPU ve Memory kısıtları eklendi (noisy neighbor sorununu engellemek için).
- **Internal DNS:** Servislerin birbirbirleriyle `identity-api`, `catalog-api` gibi K8s servis isimleri üzerinden konuşması sağlandı.
- **ConnectionStrings:** Tüm bağlantı cümleleri Kubernetes iç ağ yapısına uygun hale getirildi.

---
Bu aşamadan sonra her şeyin çalıştığından emin olduğumuzda, bu manifestleri Helm şablonlarına dönüştürerek ArgoCD'ye teslim edeceğiz.
