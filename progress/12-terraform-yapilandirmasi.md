# Adım 02: Terraform Modüler Altyapı Tasarımı

Bu aşamada, Multipass üzerinde çalışacak olan tüm sunucuların otomatik ve standart bir şekilde yönetilmesi için Terraform altyapısını kuruyoruz.

## Neler Yapılacak?
1. **Multipass Sağlayıcısı (Provider) Kurulumu:** Terraform'un Multipass ile konuşmasını sağlayacak yapılandırma yapılacak.
2. **Base Modül Oluşturma (`multipass_instance`):** İsim, CPU, RAM, Disk ve Cloud-init parametrelerini alan genel bir "sunucu motoru" yazılacak.
3. **Cloud-init Entegrasyonu:** Sunucular ilk açıldığında içine sizin SSH anahtarınızın gömülmesi ve temel paketlerin (`curl`, `git`, `docker` vb.) kurulması sağlanacak.
4. **Orkestrasyon (`main.tf`):** Tüm sunucular (master, worker, jenkins vb.) bu modül kullanılarak tek bir komutla ayağa kaldırılabilir hale getirilecek.

## Neden Bu Yöntem? (Avantajlar)
- **Standartlaşma:** Tüm VM'ler aynı işletim sistemi ve temel paketlerle açılır, "benim makinemde çalışıyordu" sorunu ortadan kalkar.
- **Hız ve Tekrarlanabilirlik:** Bir sunucuyu silip saniyeler içinde aynı ayarlarla (IaC) tekrar ayağa kaldırabiliriz.
- **Kaynak Kontrolü:** RAM/CPU limitleri merkezi bir dosyadan yönetilir, ana makine (host) aşırı yüklenmeye karşı korunur.
- **Görünürlük:** `terraform plan` ile neyin değişeceğini işlem yapılmadan önce görebiliriz.

## Sunucu Kaynak Dağılım Listesi
Bu adımda uygulanacak nihai limitler:

| Sunucu Adı | CPU | RAM | Disk | Temel Görev |
| :--- | :--- | :--- | :--- | :--- |
| **k3s-master** | 1 | 2GB | 10GB | Kubernetes Control Plane |
| **k8s-worker** | 2 | 4GB | 25GB | Uygulama Yükü (eShop) |
| **jenkins.local** | 1 | 3GB | 15GB | CI/CD Pipeline |
| **monitoring-srv** | 1 | 2GB | 15GB | Metrik ve Loglama |
| **security.local** | 1 | 3GB | 10GB | Güvenlik Taramaları |
| **git.local** | 1 | 1.5GB | 15GB | Git ve Container Registry |
| **vault.local** | 1 | 512MB | 5GB | Secret Management |

## Teknik Detaylar
- **Provisioner:** `local-exec` ile kurulum sonrası bilgilendirme mesajları oluşturulacak.
- **SSH:** `~/.ssh/id_rsa.pub` (veya sizin belirlediğiniz anahtar) her makineye otomatik aktarılacak.

**Devam edeyim mi?**

ONAY BEKLENİYOR
