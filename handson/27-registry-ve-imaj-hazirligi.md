# Hands-on 27: Kubernetes İmaj Çekme ve Registry Hazırlığı

Bu rehber, Kubernetes'in yerel registry'nizden (`git.local`) nasıl imaj çekeceğini ve gereken altyapı servislerini nasıl hazırlayacağınızı açıklar.

## 🛠️ 1. Gitea Container Registry'yi Hazırlama
Gitea üzerinde bir "Container Registry" kullanabilmek için:
- Kullanıcı profilinden bir **App Token** oluşturulmalıdır.
- Bu token ile `docker login git.local:3000` yapılabilmelidir.

## 🔑 2. Kubernetes pullSecret Oluşturma
Kubernetes'in `git.local`'e login olabilmesi için şu komutu çalıştıracağız:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=git.local:3000 \
  --docker-username=<GITEA_USER> \
  --docker-password=<GITEA_TOKEN> \
  --docker-email=<EMAIL>
```

## 🏗️ 3. Geçici Test Deployment (Probing)
Helm'den önce her şeyin çalıştığını anlamak için basit bir dosya oluşturun (`test-deploy.yaml`):

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
      - name: regcred  # Yukarıda oluşturduğumuz secret
      containers:
      - name: nginx
        image: git.local:3000/admin/nginx:latest # Registry'ye pushladığınız bir imaj
```

## ⚠️ Dikkat Edilmesi Gerekenler
- **DNS:** Tüm K8s node'ları `git.local` ismini çözebiliyor olmalıdır (Adım 25'te yapmıştık).
- **Insecure Registry:** Gitea eğer HTTP üzerinden (port 3000) çalışıyorsa, K3s'in `/etc/rancher/k3s/registries.yaml` dosyasına bu registry'nin "insecure" olduğu eklenmelidir.

---
Bu adımlar tamamlandığında, Helm ile mikroservis deploy etmek sadece bir "Values" dosyasını değiştirmek kadar kolay olacak.
