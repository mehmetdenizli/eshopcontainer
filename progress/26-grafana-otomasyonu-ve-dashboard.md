# Adım 26: Grafana Otomasyonu (Provisioning) ve Dashboard Yayını

Bu doküman, Grafana üzerindeki veri kaynaklarının ve dashboard'ların manuel müdahale gerektirmeden, kodla (provisioning) nasıl ayağa kaldırıldığını açıklar.

## ⚙️ Datasource Otomasyonu (Provisioning)
Grafana veri kaynakları (Prometheus ve Loki), konteyner her başladığında otomatik olarak hazır hale gelir. 
- **Dosya:** `ansible/templates/monitoring/datasource-provider.yml.j2`
- **İçerik:**
  - **Prometheus:** `http://prometheus:9090` (Varsayılan veri kaynağı)
  - **Loki:** `http://loki:3100`

## 📊 Dashboard Otomasyonu (Unified Observability)
Altyapıdaki tüm sunucuları tek ekranda izlemeyi sağlayan "eShop Unified Observability" dashboard'u sisteme entegre edildi.
- **Dosya:** `ansible/templates/monitoring/unified-dashboard.json.j2`
- **Sağlayıcı:** `ansible/templates/monitoring/dashboard-provider.yml.j2`

### Dashboard Özellikleri:
1. **Host Değişkeni:** Üstteki menüden sunucu seçimi yapılabilir.
2. **Service Değişkeni:** Seçili sunucudaki konteyner/mikroservis bazlı filtreleme yapılabilir.
3. **Metrik + Log:** CPU/RAM kullanım grafikleri ile uygulama logları aynı zaman çizelgesinde alt alta gösterilir.

## 🛠️ Uygulama Adımları
Ansible playbook (`playbooks/monitoring-setup.yml`) ile şu işlemler yapılmıştır:
1. Provisioning YAML dosyaları sunucuya kopyalandı.
2. `docker-compose.yml` güncellenerek bu dosyalar `/etc/grafana/provisioning/` altına mount edildi.
3. Grafana konteynerı yeniden başlatılarak konfigürasyonun aktif olması sağlandı.

## ✅ Sonuç
Artık Grafana sunucusu tamamen silinse bile, Ansible ile tek komutta tüm veri kaynakları ve dashboard'lar eski haline dönecek şekilde **"Immutable Infrastructure"** prensibine uygun hale getirilmiştir.
