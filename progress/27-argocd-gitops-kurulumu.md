# Adım 27: GitOps Dönüşümü ve ArgoCD Kurulumu

Bu aşamada projenin sürekli dağıtım (CD) stratejisi "Push" modelinden "Pull" (GitOps) modeline taşınmaktadır.

## 🚀 GitOps Vizyonu
Artık Jenkins sadece CI (Build & Test) süreçlerinden sorumlu olacak. Kubernetes üzerindeki uygulamaların durumu (desired state) Git repolarındaki manifestolar tarafından belirlenecek ve **ArgoCD** bu durumu cluster ile otomatik olarak senkronize edecek.

## 🏗️ Mimari Yapı
- **ArgoCD Server:** K3s cluster üzerinde çalışır (Controller yapısı gereği).
- **Yönetim Merkezi:** Jenkins sunucusu (`jenkins.local`). 
- **Erişim:** `argo.local` domaini Jenkins sunucusuna yönlendirilmiş, oradan K3s'e proxy yapılmaktadır.
- **CLI:** ArgoCD CLI Jenkins sunucusuna kurularak otomasyon sağlanmaktadır.

## 🛠️ Yapılan İşlemler
1. **Domain Kaydı:** `argo.local` domaini envanterde `192.168.2.89` (Jenkins) olarak tanımlandı.
2. **K3s Hazırlık:** ArgoCD için `argocd` namespace'i oluşturuldu.
3. **Kurulum:** ArgoCD manifestoları K3s cluster'ına uygulandı.
4. **Proxy Ayarları:** Jenkins sunucusu üzerinden ArgoCD UI'a erişim için Nginx reverse proxy yapılandırıldı.

## 🔐 Sertifika ve Erişim Sorunlarının Çözümü (Insecure Mode)
Kurulum sonrası `http://argo.local` üzerinden girişte yaşanan "401 Unauthorized" ve sürekli login sayfasına yönlendirme sorunu, tarayıcıların HTTP üzerinden gelen "Secure" işaretli session cookie'lerini reddetmesinden kaynaklanmıştır. Bu durumu aşmak için sistem "Insecure" moda çekilmiştir:

1. **ArgoCD Yapılandırması (`argocd-cm`):**
   ConfigMap üzerinde aşağıdaki parametreler aktif edilerek ArgoCD'nin HTTP üzerinden çalışması sağlandı:
   - `server.insecure: "true"`
   - `server.enable.tls: "false"`

2. **Server Deployment Güncellemesi:**
   `argocd-server` deployment'ına `--insecure` parametresi eklenerek binary seviyesinde TLS zorunluluğu kaldırıldı.

3. **Reverse Proxy (Nginx) Düzenlemesi:**
   Jenkins sunucusundaki Nginx, ArgoCD backend'ine HTTPS yerine HTTP üzerinden (`port 80`) gidecek şekilde güncellendi.

Bu düzenlemeler sonucunda, yerel ağda SSL sertifikası karmaşası yaşamadan `argo.local` üzerinden stabil bir erişim sağlanmıştır.

**Checkpoint:** `argocd-ready-v1`

---
**ANTIGRAVITY NOTU:** GitOps projemizin "otopilot" sistemidir. Artık bir YAML dosyasını değiştirmek, uygulamayı güncellemek için yeterli olacak.
