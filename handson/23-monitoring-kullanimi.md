# Hands-on 23: PLGA Monitoring Stack Kullanımı

Gözlem kulemiz (Monitoring Stack) aktif! `monitoring-srv` (192.168.2.87) üzerinden tüm bilgilere erişebilirsiniz.

## 🎨 1. Grafana Giriş ve Veri Kaynakları
Grafana'ya erişin:
- **URL:** [http://192.168.2.87:3003](http://192.168.2.87:3003)
- **Kullanıcı:** `admin`
- **Şifre:** `admin`

### Veri Kaynakları (Data Sources):
Veri kaynakları otomatik olarak (provisioned) eklenmiştir:
1. **Prometheus:** `http://prometheus:9090` (Metrikler için hazır)
2. **Loki:** `http://loki:3100` (Loglar için hazır)
Doğrulamak için **Connections** -> **Data Sources** menüsüne bakabilirsiniz.

## 🔍 2. Logları Keşfetmek (Loki)
Giriş yaptıktan sonra sol menüden **Explore** kısmına gelin:
- Select Data Source: **Loki**
- Query (Code modunda): `{job="kubernetes-pods"}` veya `{instance="jenkins.local"}` 
- **Run Query** butonuna basın. Gerçek zamanlı logları göreceksiniz.

## 📊 3. Metrikleri Görmek (Prometheus)
**Explore** kısmında:
- Select Data Source: **Prometheus**
- Metric Select: `node_cpu_seconds_total`
- Bu metrik, Alloy'un topladığı host CPU verisidir.

## 🤖 4. Alloy: Yeni Nesil Ajan
Alloy'un ne topladığını ve nasıl çalıştığını görsel olarak görmek için:
- **URL:** [http://192.168.2.87:12345](http://192.168.2.87:12345)
- Burada hangi Docker konteynerlarını "keşfettiğini" (Discovery) ve hangi verileri "crawl" ettiğini görebilirsiniz.

---
Bir sonraki adımda, tüm sunuculara Alloy kurarak bu kuleye veri göndermelerini sağlayacağız!
