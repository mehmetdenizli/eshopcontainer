# Adım 36: DevSecOps Yol Haritası (CI/CD, Güvenlik ve Secret Yönetimi)

Bu belge, proje altyapısında kurulu olan araçların (Jenkins, ArgoCD, SonarQube, Trivy, Vault) birbirine nasıl entegre edileceğini ve uçtan uca otomasyon planını açıklar.

## 1. Planın Mimari Özeti (Big Picture)
Hedeflenen akış:
**Kod Push** (Gitea) → **Pipeline Tetikleme** (Jenkins) → **Kod Analizi** (SonarQube) → **Build/Push** (Docker) → **İmaj Tarama** (Trivy) → **GitOps Güncelleme** (Git repo) → **Otomatik Deploy** (ArgoCD) → **Secret Entegrasyonu** (Vault).

---

## 2. Uygulama Adımları ve Fazlar

### Faz 1: Secret Management (Vault & Kubernetes)
* **Vault Yapılandırması:** Vault'un "unseal" yapılması ve Kubernetes Auth Method'un aktif edilmesi.
* **Entegrasyon:** `Vault Agent Injector` kullanılarak podların içindeki environment variable'ların veya dosyaların otomatik olarak Vault'tan beslenmesi.
* **Hedef:** Mikroservislerin DB connection string ve şifrelerini `webapp.yaml` içinde düz metin olarak tutmaktan kurtulmak.

### Faz 2: CI Pipeline Geliştirme (Jenkins & Security)
* **Shared Library:** Tüm mikroservisler için ortak bir Jenkins Shared Library oluşturulması.
* **SonarQube Entegrasyonu:** Her build adımında kodun `security.local` üzerindeki SonarQube'e gönderilmesi ve "Quality Gate" kontrolü.
* **Trivy Scan:** Docker imajı pushlanmadan önce kritik (CRITICAL) açık olup olmadığının taranması.
* **Registry Push:** Temizlenen imajların `git.local:3000` registry'sine gönderilmesi.

### Faz 3: Helm Chart ve GitOps (ArgoCD)
* **Helm Dönüşümü:** `manifests/` altındaki statik YAML dosyalarının Helm Chart yapısına (`values.yaml`) dönüştürülmesi.
* **Deploy Repo:** Ayrı bir Git reposunda (veya `eshopcontainer-deploy` branch'inde) Kubernetes manifestlerinin tutulması.
* **ArgoCD Sync:** Jenkins pipeline'ının sonunda, yeni imaj versiyonunun Git reposuna commitlenmesi ve ArgoCD'nin bu değişikliği algılayıp `k3s-master` üzerine "Sync" yapması.

---

## 3. İlk Odak Noktası (Quick Win)
En öncelikli olarak **Faz 1 (Vault)** ve **Faz 2 (Jenkins)** arasında seçim yapmalıyız. 

1. **Öneri 1 (Güvenlik Öncelikli):** Önce Vault ile podları güvenli hale getirelim.
2. **Öneri 2 (Otomasyon Öncelikli):** Önce tek bir servis (örn: WebApp) için Jenkins -> Gitea -> Docker -> ArgoCD akışını kuralım.

---
**Durum:** Planlama Aşamasında 📋
