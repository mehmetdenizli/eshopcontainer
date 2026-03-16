# Hands-on 28: Manuel Kubernetes Manifestleri ile Dağıtım

Bu rehber, eShopOnContainers projesinin Kubernetes (K3s) üzerine manuel manifest (YAML) dosyalarıyla nasıl dağıtıldığını ve sunucu tarafındaki operasyonel adımları açıklar.

## 📁 1. Manifestlerin Sunucuya Senkronizasyonu
Local makinedeki (Macbook) `manifests/` dizini, Ansible kullanılarak K3s Master node'una (`/home/ubuntu/manifests/`) kopyalanmıştır.

```bash
# Macbook üzerinden çalıştırma:
ansible k3s_master -i ansible/inventory/hosts.ini -m file -a "path=/home/ubuntu/manifests state=directory" --become
ansible k3s_master -i ansible/inventory/hosts.ini -m copy -a "src=manifests/ dest=/home/ubuntu/manifests/" --become
```

## 🚀 2. Uygulama ve Bağımlılık Sırası

### Adım 1: Infrastructure (Altyapı)
Önce Postgres, Redis ve RabbitMQ servisleri ayağa kaldırılır. Bu servisler verilerini şu an için pod içinde tutmaktadır (StatefulSet/PVC yapısına Helm aşamasında geçilecektir).

```bash
kubectl apply -f /home/ubuntu/manifests/infrastructure/
```

### Adım 2: Application (Uygulamalar)
İmajlar Registry'ye (`git.local:3000`) pushlandıktan sonra mikroservisler dağıtılır:

```bash
kubectl apply -f /home/ubuntu/manifests/apps/
```

## 🔍 3. Doğrulama ve Sorun Giderme

### Pod Durumlarını Kontrol Etme:
```bash
kubectl get pods -w
```

### ImagePullBackOff Sorunu:
Eğer imaj pushlanmadan önce deployment yapıldıysa veya imaj bulunamadıysa `ImagePullBackOff` hatası alınabilir. İmaj pushlandıktan sonra ilgili podu silerek yeniden oluşmasını tetikleyin:
```bash
kubectl delete pod <pod-adi>
```

### Pod Detaylarını İnceleme:
Hata analizi için (örneğin Registry login hatası):
```bash
kubectl describe pod <pod-adi>
```

## 📜 4. Kaydedilen Önemli Kararlar
- **Resource Limits:** Tüm podlara CPU (limits: 250m-500m) ve Memory (limits: 256Mi-512Mi) kısıtları eklendi.
- **Service Naming:** Kubernetes iç haberleşmesi için `identity-api`, `catalog-api` gibi standart servis isimleri kullanıldı (K8s DNS).
- **Environment:** Veritabanı bağlantı cümleleri (ConnectionStrings) bu `Internal DNS` isimlerine göre güncellendi.

---
Bu "Manuel" aşama, Helm şablonlarımızın doğruluğunu test etmek için bir referans noktasıdır.
