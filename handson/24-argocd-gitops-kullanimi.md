# Hands-on 24: ArgoCD ve GitOps Kurulum Rehberi

Bu rehber, ArgoCD'nin K3s üzerine kurulumunu ve Jenkins sunucusu üzerinden erişilebilir hale getirilmesini adım adım açıklar.

## 🛠️ 1. ArgoCD Kurulumu (K3s Master üzerinde)

ArgoCD'yi Kubernetes cluster'ına kurmak için şu komutlar sırasıyla çalıştırılmıştır:

```bash
# 1. Namespace oluşturma
kubectl create namespace argocd

# 2. Stable manifestoların uygulanması
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. ArgoCD Server'ı dış dünyaya (MetalLB) açmak için LoadBalancer yapma
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## 🔒 2. İlk Giriş Şifresini Almak

ArgoCD kurulduğunda otomatik olarak bir admin şifresi oluşturur. Bu şifreyi almak için:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
> **Not:** Şifreyi aldıktan sonra UI üzerinden mutlaka değiştirmeniz önerilir.

## 🌐 3. Domain ve Proxy Yapılandırması (Jenkins Server)

ArgoCD'ye `http://argo.local` üzerinden erişebilmek için Jenkins sunucusu üzerinde bir Nginx Reverse Proxy kurulmuştur.

### Nginx Konfigürasyonu (`/etc/nginx/sites-available/argocd`):
```nginx
server {
    listen 80;
    server_name argo.local;

    location / {
        proxy_pass https://192.168.2.101; # ArgoCD Service External IP
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        proxy_ssl_verify off; # Kendi imzalı sertifika için
        proxy_read_timeout 90;
    }
}
```

## 💻 4. ArgoCD CLI Kurulumu (Jenkins Server)

Otomasyon süreçleri (CI/CD) için Jenkins sunucusuna ArgoCD CLI aracı yüklenmiştir:

```bash
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

## 🎨 5. Arayüze Giriş ve Kullanım
- **URL:** [http://argo.local](http://argo.local)
- **Kullanıcı:** `admin`
- **Şifre:** Adım 2'de elde edilen şifre.

### CLI ile Giriş Denemesi:
```bash
argocd login argo.local --username admin --password <SİFRE> --insecure
```

## ⚠️ Karşılaşılan Hatalar ve Çözümleri

### 1. HTTP Üzerinden Login Sorunu (401 Unauthorized)
**Hata:** `http://argo.local` adresine gidildiğinde bilgiler doğru olsa bile "Unauthorized" hatası alınması veya sürekli login sayfasına yönlendirilmesi.
**Neden:** ArgoCD varsayılan olarak HTTPS üzerinden çalışır. Tarayıcılar, HTTP üzerinden gelen "Secure" işaretli session cookie'lerini reddettiği için oturum açılamıyordu.
**Çözüm (Insecure Mode):**
- ArgoCD ConfigMap (`argocd-cm`) güncellendi: `server.insecure: "true"`.
- `argocd-server` deployment parametrelerine `--insecure` eklendi.
- Nginx Reverse Proxy backend protokolü HTTPS'ten HTTP'ye çekildi.

---
Bu kurulum sayesinde, Jenkins sadece kodumuzu paketleyecek ("CI"), ArgoCD ise Git üzerindeki değişiklikleri cluster'a yansıtacaktır ("CD").
