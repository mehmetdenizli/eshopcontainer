# eShopOnContainers Yerel DevOps Altyapı Projesi

Bu dokümantasyon, eShopOnContainers projesinin Multipass, K3s ve Terraform kullanılarak yerel bir DevOps altyapısına taşınma sürecini takip eder.

## Proje Vizyonu
Eksiksiz bir CI/CD hattı, merkezi izleme (monitoring), güvenlik taramaları ve gizli yönetim (secret management) içeren, profesyonel standartlarda bir yerel geliştirme ortamı oluşturmak.

## Altyapı Bileşenleri (Inventory)

| Hostname | IP | Görevler | Kaynaklar |
| :--- | :--- | :--- | :--- |
| **k3s-master** | 192.168.2.85 | Control Plane, Gateway API | 1 CPU, 2GB RAM, 10GB Disk |
| **k8s-worker** | 192.168.2.86 | Application Pods | 2 CPU, 4GB RAM, 25GB Disk |
| **jenkins.local** | 192.168.2.89 | Jenkins CI/CD | 1 CPU, 3GB RAM, 15GB Disk |
| **monitoring-srv** | 192.168.2.87 | Prometheus, Loki, Grafana, Alloy | 1 CPU, 2GB RAM, 15GB Disk |
| **security.local** | 192.168.2.91 | SonarQube, Trivy | 1 CPU, 3GB RAM, 10GB Disk |
| **git.local** | 192.168.2.90 | Gitea, Image Registry | 1 CPU, 1.5GB RAM, 15GB Disk |
| **vault.local** | 192.168.2.92 | Hashicorp Vault | 1 CPU, 512MB RAM, 5GB Disk |

## Dizin Yapısı
- `/terraform/modules/`: Her bir sunucu için özelleştirilmiş Terraform modülleri.
- `/handson/`: Uygulamalı adım adım kurulum rehberleri (Kod ve config içerir).
- `/progress/`: Teknik adımların ve proje durumunun özet kayıtları.
- `/ansible/`: (Opsiyonel) Sunucu içi yapılandırmalar.
- `/src/`: eShopOnContainers kaynak kodları.

## İlerleme Kayıtları
1. [README.md](./README.md) - Proje Genel Bakış
2. [ROADMAP.md](./ROADMAP.md) - Stratejik Yol Haritası
3. [11-analiz-ve-planlama.md](./11-analiz-ve-planlama.md) - Analiz ve Kaynak Planı
4. [12-terraform-yapilandirmasi.md](./12-terraform-yapilandirmasi.md) - Terraform Altyapı Tasarımı
5. [13-sunucularin-moduler-kurulumu.md](./13-sunucularin-moduler-kurulumu.md) - Sunucuların Modüler Provisioning Süreci
6. [14-k3s-otomasyon-stratejisi.md](./14-k3s-otomasyon-stratejisi.md) - K3s ve Altyapı Otomasyonu (Ansible)
7. [15-k3s-kurulumu-basarili.md](./15-k3s-kurulumu-basarili.md) - K3s Cluster Kurulumu Başarılı
8. [16-kubeconfig-senkronizasyonu.md](./16-kubeconfig-senkronizasyonu.md) - Kubeconfig Senkronizasyonu ve Lokal Erişim
9. [17-loadbalancer-ve-networking.md](./17-loadbalancer-ve-networking.md) - MetalLB ve LoadBalancer Yapılandırması
10. [18-docker-kurulumlari-tamamlandi.md](./18-docker-kurulumlari-tamamlandi.md) - Tüm Sunuculara Docker Kurulumu (Ansible)
11. [19-gitea-ve-registry-kurulumu.md](./19-gitea-ve-registry-kurulumu.md) - Gitea ve Container Registry Kurulumu
12. [20-jenkins-fabrikasi-kurulumu.md](./20-jenkins-fabrikasi-kurulumu.md) - Jenkins CI/CD Fabrikası Kurulumu
13. [21-sonarqube-ve-guvenlik-entegrasyonu.md](./21-sonarqube-ve-guvenlik-entegrasyonu.md) - SonarQube ve Güvenlik (Trivy) Entegrasyonu
14. [22-vault-secret-management.md](./22-vault-secret-management.md) - Hashicorp Vault (Secret Management) Kurulumu
15. [23-monitoring-stratejisi.md](./23-monitoring-stratejisi.md) - Monitoring Stratejisi (PLGA Stack) ve Gözlem Kulesi
16. [24-detayli-izleme-aktif.md](./24-detayli-izleme-aktif.md) - Detaylı İzleme ve Alloy Dağıtımı Tamamlandı
17. [25-domain-tabanli-iletisim-ve-kalicilik.md](./25-domain-tabanli-iletisim-ve-kalicilik.md) - Domain Tabanlı İletişim ve /etc/hosts Kalıcılığı
18. [26-grafana-otomasyonu-ve-dashboard.md](./26-grafana-otomasyonu-ve-dashboard.md) - Grafana Otomasyonu (Provisioning) ve Dashboard Yayını
19. [27-argocd-gitops-kurulumu.md](./27-argocd-gitops-kurulumu.md) - GitOps Dönüşümü ve ArgoCD Kurulumu
20. [28-git-onarim-ve-branch-yonetimi.md](./28-git-onarim-ve-branch-yonetimi.md) - Git Onarım ve Yanlış Branch Kurtarma Operasyonu
21. [29-helm-mimarisi-ve-standartlar.md](./29-helm-mimarisi-ve-standartlar.md) - Helm Mimarisi ve Template Standardizasyonu
22. [30-helm-oncesi-eksiklik-analizi.md](./30-helm-oncesi-eksiklik-analizi.md) - Helm Öncesi Eksiklik Analizi ve Hazırlık Planı
23. [31-manuel-manifest-stratejisi.md](./31-manuel-manifest-stratejisi.md) - Kubernetes Manifestleri ve Manuel Uygulama Stratejisi
24. [32-manuel-dagitim-ve-dogrulama.md](./32-manuel-dagitim-ve-dogrulama.md) - Manuel Kubernetes Dağıtımının Başarıyla Tamamlanması
