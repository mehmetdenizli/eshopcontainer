# Proje Yol Haritası (ROADMAP)

Bu belge, altyapı kurulumunun aşamalarını ve hedeflerini içerir.

## Faz 1: Altyapı Hazırlığı (Güncel)
- [x] Mevcut yapılandırmaların analizi.
- [x] Geçersiz dosyaların temizlenmesi.
- [x] Kaynak planlamasının yapılması.
- [x] `handson/` dizin yapısının oluşturulması.
- [x] Terraform modüler yapısının kurulması.
- [x] Multipass üzerinde ilk VM'in (k3s-master) provision edilmesi.

## Faz 2: Kubernetes ve Networking
- [x] K3s Cluster otomasyon yapısının (Ansible) kurulması.
- [x] K3s Cluster kurulumu (Master & Worker).
- [x] Kubernetes Gateway API yapılandırması (MetalLB L2).
- [x] `/etc/hosts` senkronizasyonu ve dokunulmazlık (`chattr +i`) ayarları.

## Faz 3: DevOps Araç Seti
- [x] Tüm sunuculara Docker & Docker Compose kurulumu.
- [x] Gitea (Git Server) ve Yerel Docker Registry kurulumu.
- [x] Jenkins CI/CD pipeline tasarımları.
- [x] SonarQube ve Trivy güvenlik entegrasyonları.
- [x] Hashicorp Vault ile secret yönetimi.

## Faz 4: İzleme ve Validasyon
- [x] Prometheus & Grafana ile metrik takibi.
- [x] Loki ile merkezi loglama.
- [ ] eShopOnContainers servislerinin K8s üzerine deploy edilmesi.
- [ ] Uçtan uca testlerin yapılması.

## Faz 5: GitOps ve Sürekli Dağıtım (Yeni)
- [x] ArgoCD kurulumu ve K3s entegrasyonu.
- [ ] Helm Chart mimarisinin kurulması.
- [ ] GitOps (ArgoCD) ile otomatik senkronizasyon.
