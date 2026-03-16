# Hands-on 27: Kubernetes İmaj Çekme ve Registry Hazırlığı

Bu rehber, Kubernetes'in (K3s) yerel registry'den (`git.local:3000`) imaj çekebilmesi için sunucu tarafında yapılan teknik yapılandırmaları detaylandırır.

## 🛠️ 1. Gitea Container Registry Hazırlığı (Sunucu Tarafı)
K3s node'larının Gitea'ya HTTP (insecure) üzerinden erişebilmesi için tüm node'larda (Master ve Worker) şu dosya oluşturulmalıdır:

**Dosya:** `/etc/rancher/k3s/registries.yaml`
```yaml
mirrors:
  "git.local:3000":
    endpoint:
      - "http://git.local:3000"
```

### Yapılandırmanın Uygulanması:
Master node üzerinde:
```bash
sudo systemctl restart k3s
```
Worker node üzerinde:
```bash
sudo systemctl restart k3s-agent
```

## 🔑 2. Kubernetes Pull Secret (`regcred`) Oluşturma
Kubernetes'in özel (private) registry'den imaj çekebilmesi için `default` namespace altında bir yetkilendirme secret'ı oluşturduk.

```bash
kubectl create secret docker-registry regcred \
  --docker-server=git.local:3000 \
  --docker-username=gitea \
  --docker-password=430bead450a6a1206922ca666587926faf53ddb2 \
  --docker-email=foriinji@gmail.com
```

## 🏗️ 3. Manifestlerde Kullanımı
Tüm Deployment manifestlerinde `spec.template.spec` altına şu bölüm eklenmelidir:

```yaml
spec:
  imagePullSecrets:
    - name: regcred
  containers:
    - name: identity-api
      image: git.local:3000/gitea/identity-api:latest
```

## ⚠️ Kritik Bilgiler
- **Insecure Registry:** `/etc/rancher/k3s/registries.yaml` dosyası olmazsa K3s imaj çekmeye çalışırken HTTPS hatası verir.
- **Port:** Registry portunun `:3000` olduğu hem secret içinde hem de `registries.yaml` içinde belirtilmelidir.
- **Namespace:** Secret hangi namespace'de oluşturulduysa, Deployment da o namespace'de olmalıdır.

---
Bu adımlar sayesinde K3s kümemiz, Gitea Container Registry ile tam uyumlu hale getirilmiştir.
