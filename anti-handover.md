# Anti-Handover: Proje Özeti (Handover Summary)

Bu dosya, bir sonraki Antigravity oturumu başladığında projeye kaldığı yerden hızla devam edebilmesi için oluşturulmuştur.

## 📌 Proje Kimliği
- **Proje Adı:** eShopOnContainers Yerel DevOps Altyapısı
- **Rol:** Senior DevOps & Platform Architect
- **Hedef:** Multipass (K3s) + Terraform + Jenkins + Monitoring + Vault içeren tam kapsamlı yerel altyapı.

## 🛠️ Teknik Kısıtlar ve Kurallar
- **Ana Makine Kaynakları:** 24GB RAM, 10 CPU, 100GB Disk.
- **VM Dağılımı (Güncel):** Toplam 16GB RAM, 8 CPU kullanılıyor.
- **Dil:** Türkçe (Teknik terimler İngilizce).
- **Mod:** Adım adım / İnteraktif (Her adımdan sonra ONAY BEKLENİYOR).
- **Dokümantasyon:** `/progress/` ve `/handson/` dizinleri altında 11 numaradan başlayarak kayıt tutuluyor.

## 📋 Mevcut Envanter (Tüm Sunucular Aktif)

| Hostname | IP | VM Name | CPU | RAM |
| :--- | :--- | :--- | :--- | :--- |
| k3s-master | 192.168.2.85 | k3s-master | 1 | 2GB |
| k8s-worker | 192.168.2.86 | k8s-worker | 2 | 4GB |
| monitoring-srv | 192.168.2.87 | monitoring-srv | 1 | 2GB |
| jenkins.local | 192.168.2.89 | jenkins-srv | 1 | 3GB |
| git.local | 192.168.2.90 | git-srv | 1 | 1.5GB |
| security.local | 192.168.2.91 | security-srv | 1 | 3GB |
| vault.local | 192.168.2.92 | vault-srv | 1 | 512MB |

## ✅ Tamamlanan Adımlar
1. **Analiz & Planlama:** 24GB RAM limitine göre 16GB VM paylaştırıldı.
2. **Terraform Altyapısı:** `multipass_instance` modülü ile modüler yapı kuruldu.
3. **Full Provisioning:** Tüm 7 sunucu tek seferde Terraform ile ayağa kaldırıldı.
4. **IP Senkronizasyonu:** `hosts_to_paste.txt` dosyası tüm güncel IP'lerle oluşturuldu.
5. **Ansible Altyapısı:** `inventory/hosts.ini` ve K3s kurulum playbook'u hazırlandı.
6. **Kubeconfig:** Master'dan Mac'e senkronize edildi, IP dinamik güncellendi.
7. **LoadBalancer (MetalLB):** L2 modunda 192.168.2.100-110 aralığıyla kuruldu.
8. **Docker Altyapısı:** Tüm sunuculara (7 adet) Docker Engine & Compose kuruldu.
9. **Gitea & Registry:** Git ve Paket sunucusu (Gitea) git-srv üzerinde aktif edildi.
10. **Jenkins Fabrikası:** jenkins-srv üzerinde tüm pluginlerle (Sonar-K8s-Docker) birlikte kuruldu.
11. **Güvenlik & Kalite:** security-srv üzerinde SonarQube (LTS) kuruldu, Jenkins'e Trivy entegre edildi.
12. **Secret Management:** vault-srv (10GB Disk) üzerinde Hashicorp Vault aktif edildi.
13. **Monitoring (PLGA):** Tüm 7 sunucuya basitleştirilmiş Alloy ajanları dağıtıldı. cAdvisor (konteyner metrikleri) ve K8s pod logları (job="kubernetes-pods") toplanıyor. Grafana dashboard'ları temizlendi ("Clean Slate").
14. **Domain Persistence:** Tüm sunucularda `/etc/hosts` dosyası senkronize edildi ve `cloud-init` kilidi kaldırılarak kalıcı hale getirildi.
15. **Checkpoint:** Sistem bu haliyle `monitoring-stable-v1` etiketiyle (git tag) damgalandı ve repoya puslandı.
16. **GitOps Dönüşümü:** ArgoCD K3s üzerine kuruldu, Jenkins sunucusu üzerinden Proxy (`argo.local`) ve CLI erişimi yapılandırıldı. Insecure mode ile SSL sorunları çözüldü.
17. **Checkpoint:** `argocd-ready-v1` etiketiyle sistem bu noktada sabitlendi.
18. **Manuel Manifest Stratejisi:** `manifests/` dizini oluşturuldu; altyapı ve uygulama servisleri için ham Kubernetes YAML dosyaları hazırlandı.
19. **K8s Deployment (Success):** Tüm mikroservisler ve altyapı (Postgres, Redis, RabbitMQ) K3s üzerinde ayağa kaldırıldı. Insecure registry ve `regcred` secret yapılandırması tamamlandı. Podlar `Running` durumunda.
20. **Gateway API:** Ingress yerine modern Gateway API (`eshop-gateway`) ve `HTTPRoute` yapısı kuruldu. Traefik 3.x üzerinde 5 farklı domain (`eshop.local`, `identity.local` vb.) için rota tanımlandı.
21. **OIDC & Proxy Fix:** WebApp ve IdentityServer arasındaki "Correlation Failed" hatası, `Program.cs` içindeki `ForwardedHeaders` yapılandırması ve Traefik `Middleware` (`X-Forwarded-Port: 80`) ile çözüldü. Yerel HTTP ortamı için SSL zorunluluğu kaldırıldı.

## 🚀 Sıradaki Adım (Next Phase)
- **Validation:** Kimlik doğrulama akışının tarayıcı üzerinden uçtan uca doğrulanması ve kullanıcı girişinin tamamlanması.

## 🔗 Aktif Servis Linkleri (Quick Access)

| Servis | URL | IP | Durum |
| :--- | :--- | :--- | :--- |
| **K3s Master** | `https://192.168.2.85:6443` | 192.168.2.85 | ✅ Aktif |
| **Gitea & Registry** | [http://192.168.2.90:3000](http://192.168.2.90:3000) | 192.168.2.90 | ✅ Aktif |
| **Jenkins** | [http://192.168.2.89:8080](http://192.168.2.89:8080) | 192.168.2.89 | ✅ Aktif |
| **SonarQube** | [http://192.168.2.91:9000](http://192.168.2.91:9000) | 192.168.2.91 | ✅ Aktif |
| **Vault** | [http://192.168.2.92:8200](http://192.168.2.92:8200) | 192.168.2.92 | ✅ Kilitli |
| **Grafana** | [http://192.168.2.87:3003](http://192.168.2.87:3003) | 192.168.2.87 | ✅ Aktif |
| **ArgoCD** | [http://argo.local](http://argo.local) | 192.168.2.89 | ✅ Aktif |

*Not: Tüm servis kullanıcı adı ve şifreleri ilgili `/handson/` dökümanlarında yer almaktadır.*

---
## 📑 Dokümantasyon ve Güncelleme Rutini (Ritual)
Her teknik adım tamamlandığında veya önemli bir değişiklik yapıldığında aşağıdaki dosyalar hiyerarşik olarak güncellenir:

1. **`/progress/` Dizini:** Yapılan işlemin teknik özeti, kullanılan kaynaklar ve bir sonraki adımın planı (Örn: `13-sunucularin-moduler-kurulumu.md`). Numaralandırma 11'den devam eder.
2. **`/handson/` Dizini:** Uygulamalı rehberler, komutlar ve konfigürasyon dosyalarının içerikleri burada paylaşılır. Başkalarının projeyi tekrar edebilmesi için "hands-on" formatındadır. **Teknik adım sürecinde karşılaşılan hatalar ve giderilme yolları burada detaylı olarak kayıt altına alınır.**
3. **`progress/README.md` & `progress/roadmap.md`:** Yeni eklenen dokümanlar README'ye linklenir, roadmap üzerindeki ilgili adım `[x]` olarak işaretlenir.
4. **`anti-handover.md`:** (Bu dosya) Projenin genel durumu, aktif envanter, IP listesi ve tamamlanan adımlar güncellenerek yeni oturumlar için hazır tutulur.
5. **`hosts_to_paste.txt`:** Eğer IP adresleri değişmişse veya yeni sunucu eklenmişse, kullanıcının kopyalaması için bu dosya güncellenir.
6. **Git Commit & Push:** Her teknik adım tamamlandığında, `dev` branch'ine teknik adımı açıklayacak şekilde commit ve push yapılır.
7. **Doküman Koruma Kuralı (BİLGİ KAYBI YASAKTIR):** Dokümantasyon güncellenirken, mevcut olan ve yeni teknik adımlarla çelişmeyen hiçbir bilgi ASLA silinmez. Antigravity, yeni bilgileri mevcut içeriği ezerek (overwrite) değil, onunla harmanlayarak veya uygun başlıklar altında ekleyerek (Append/Merge) sunmalıdır. Tarihsel bağlam ve kullanıcı adımları her zaman korunmalıdır.

**ANTIGRAVITY NOTU:** Yeni oturum açıldığında bu dosyayı (`anti-handover.md`) okuyarak kurallara ve kalınan yere göre devam et. Her yanıtın sonunda 'ONAY BEKLENİYOR' ibaresini ekle.
