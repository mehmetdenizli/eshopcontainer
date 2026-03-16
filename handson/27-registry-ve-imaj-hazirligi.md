# Hands-on 27: Kubernetes İmaj Çekme ve Registry Hazırlığı

Bu rehber, Kubernetes'in yerel registry'nizden (`git.local`) nasıl imaj çekeceğini ve gereken altyapı servislerini nasıl hazırlayacağınızı açıklar.

## 🛠️ 1. Gitea Container Registry'yi Hazırlama
Gitea üzerinde bir "Container Registry" kullanabilmek için:
- Kullanıcı profilinden bir **App Token** oluşturulmalıdır.
- Bu token ile `docker login git.local:3000` yapılabilmelidir.

### 🔧 Sunucu Tarafı Yapılandırması (Insecure Registry)
K3s node'larının Gitea'ya HTTP üzerinden erişebilmesi için tüm node'larda (Master ve Worker) şu dosya oluşturulmuştur:

**Dosya:** `/etc/rancher/k3s/registries.yaml`
```yaml
mirrors:
  "git.local:3000":
    endpoint:
      - "http://git.local:3000"
```

Master üzerinde `k3s`, worker üzerinde `k3s-agent` servisi restart edilmelidir.

## 🔑 2. Kubernetes pullSecret Oluşturma
Kubernetes'in `git.local:3000`'e login olabilmesi için oluşturduğumuz secret:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=git.local:3000 \
  --docker-username=gitea \
  --docker-password=430bead450a6a1206922ca666587926faf53ddb2 \
  --docker-email=foriinji@gmail.com
```

## 🏗️ 3. Geçici Test Deployment (Probing)
Helm'den önce her şeyin çalıştığını anlamak için basit bir test dosyası (`test-deploy.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: registry-test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      imagePullSecrets:
      - name: regcred
      containers:
      - name: nginx
        image: git.local:3000/gitea/identity-api:latest
```

## ⚠️ Dikkat Edilmesi Gerekenler
- **DNS:** Tüm K8s node'ları `git.local` ismini çözebiliyor olmalıdır.
- **Insecure Registry:** `/etc/rancher/k3s/registries.yaml` dosyası olmazsa K3s imaj çekmeye çalışırken HTTPS hatası verir.
- **Namespace:** Secret hangi namespace'de ise deployment da orada olmalıdır.

---
Bu adımlar tamamlandığında, Helm ile mikroservis deploy etmek sadece bir "Values" dosyasını değiştirmek kadar kolay olacak.
