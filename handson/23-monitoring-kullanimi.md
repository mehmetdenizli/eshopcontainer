# Hands-on 23: PLGA Monitoring Stack Kullanımı

Gözlem kulemiz (Monitoring Stack) aktif! `monitoring-srv` (192.168.2.87) üzerinden tüm bilgilere erişebilirsiniz.

## 🎨 1. Grafana Giriş ve Veri Kaynakları
Grafana'ya erişin:
- **URL:** [http://192.168.2.87:3003](http://192.168.2.87:3003)
- **Kullanıcı:** `admin`
- **Şifre:** `admin`

### Veri Kaynaklarını (Data Sources) Tanımlayın:
1. **Connections** -> **Data Sources** -> **Add Data Source**
2. **Prometheus:** URL olarak `http://prometheus:9090` girin ve Save edin.
3. **Loki:** URL olarak `http://loki:3100` girin ve Save edin.

## 🔍 2. Logları Keşfetmek (Loki)
Giriş yaptıktan sonra sol menüden **Explore** kısmına gelin:
- Select Data Source: **Loki**
- Query (Code modunda): `{container="alloy"}` veya `{service="alloy"}` 
- **Run Query** butonuna basın. Alloy'un kendi loglarını anlık olarak göreceksiniz.

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
