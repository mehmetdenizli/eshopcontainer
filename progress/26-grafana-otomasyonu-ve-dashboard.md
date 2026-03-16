# Adım 26: Grafana Otomasyonu (Provisioning) ve Dashboard Yayını

Bu doküman, Grafana üzerindeki veri kaynaklarının ve dashboard'ların manuel müdahale gerektirmeden, kodla (provisioning) nasıl ayağa kaldırıldığını açıklar.

## ⚙️ Datasource Otomasyonu (Provisioning)
Grafana veri kaynakları (Prometheus ve Loki), konteyner her başladığında otomatik olarak hazır hale gelir. 
- **Dosya:** `ansible/templates/monitoring/datasource-provider.yml.j2`
- **İçerik:**
  - **Prometheus:** `http://prometheus:9090` (Varsayılan veri kaynağı)
  - **Loki:** `http://loki:3100`

## 📊 Dashboard Durumu: "Clean Slate" (Temiz Sayfa)
Şu aşamada tüm hazır dashboard'lar sistemden kaldırılmış ve Grafana panelinde "temiz bir sayfa" açılmıştır. Bu sayede projenin ilerleyen safhalarında (Mikroservis deployment) ihtiyaca özel daha verimli dashboard'lar oluşturulması hedeflenmektedir.

## 🛠️ Uygulama Adımları
Ansible playbook (`playbooks/monitoring-setup.yml`) ile şu işlemler yapılmıştır:
1. Provisioning YAML dosyaları sunucuya kopyalandı.
2. `docker-compose.yml` güncellenerek bu dosyalar `/etc/grafana/provisioning/` altına mount edildi.
3. Grafana konteynerı yeniden başlatılarak konfigürasyonun aktif olması sağlandı.

## ✅ Sonuç
Artık Grafana sunucusu tamamen silinse bile, Ansible ile tek komutta tüm veri kaynakları ve dashboard'lar eski haline dönecek şekilde **"Immutable Infrastructure"** prensibine uygun hale getirilmiştir.
