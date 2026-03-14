# Adım 25: Domain Tabanlı İletişim ve /etc/hosts Kalıcılığı

Bu doküman, altyapıdaki sunucuların birbirleriyle statik IP'ler yerine domain isimleri üzerinden konuşmasını sağlayan yapıyı ve bu yapının yeniden başlatmalarda (reboot) bozulmaması için alınan önlemleri açıklar.

## ❓ Sorun: Cloud-init ve Sıfırlanan Hosts Dosyası
Multipass ve benzeri bulut tabanlı sunucu imajları, her açılışta `/etc/hosts` dosyasını `cloud-init` servisi üzerinden yeniden oluşturur. Bu durum, manuel veya Ansible ile eklenen özel domain kayıtlarının her reboot sonrası silinmesine neden olur.

## 🎯 Hedef: IP Bağımsız Mimari (Resilient Infrastructure)
Servislerin (Alloy -> Prometheus, Jenkins -> SonarQube vb.) birbirine bağlanırken IP adresi yerine `monitoring-srv` veya `git.local` gibi isimler kullanması hedeflenmiştir. Bu sayede IP değiştiğinde sadece tek bir merkezden (`hosts` dosyası) güncelleme yaparak tüm sistem ayağa kaldırılabilir.

## 🛠️ Çözüm: Ansible ile Kalıcı Yapılandırma
`ansible/playbooks/common-hosts.yml` playbook'u ile şu iki aşamalı çözüm uygulanmıştır:

### 1. Cloud-init Kilidinin Kaldırılması
Sunucuların hosts dosyasını sıfırlamasını engellemek için `/etc/cloud/cloud.cfg` dosyasındaki ayar güncellenmiştir:
```yaml
manage_etc_hosts: false
```
Bu komut, işletim sistemine "hosts dosyasının kontrolü artık kullanıcıdadır" talimatını verir.

### 2. Dinamik Envanter Kaydı
Ansible `blockinfile` modülü kullanılarak, projedeki tüm sunucular birbirlerinin `/etc/hosts` dosyasına otomatik olarak eklenmiştir:
```text
# --- ANSIBLE MANAGED HOSTS - ESHOP DEV ---
192.168.2.85  k3s-master
192.168.2.87  monitoring-srv
192.168.2.89  jenkins.local
...
# ----------------------------------------
```

## ✅ Kazanımlar
- **Esneklik:** Artık sunucuların IP'leri değişse bile servis konfigürasyonlarını (Alloy River, Jenkins Pipeline vb.) değiştirmemize gerek yoktur.
- **Kalıcılık:** VM'ler kapatılıp açıldığında (stop/start) domain isimleri korunmaya devam eder.
- **Güvenilirlik:** Hata ayıklama sırasında IP adresleri yerine anlamlı isimlerle (Örn: `ping git.local`) işlem yapılabilir.

---
**ANTIGRAVITY NOTU:** Bu adım, "Single Point of Failure" riskini azaltan ve altyapıyı profesyonel standartlara taşıyan kritik bir dokunuştur.
