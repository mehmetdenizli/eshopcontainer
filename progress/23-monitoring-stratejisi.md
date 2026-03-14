# Adım 23: Monitoring Stratejisi (PLGA + Alloy)

## 🎯 Vizyon: "Single Pane of Glass" (Birleşik İzleme Ekranı)
Bu stratejinin hedefi, bir sistem hatası olduğunda (Örn: `catalog-api` çöktüğünde), hem CPU/RAM grafiklerini hem de hata loglarını **tek bir saniyede** ve **tek bir ekranda** birleşik olarak görebilmektir.

## 🧱 1. Veri Kaynakları: PLG Stack
- **Prometheus**: Sayısal metriklerin (CPU, RAM, istek sayısı) kalbi.
- **Loki**: Logların (günlüklerin) verimli ve hızlı tutulduğu depo.
- **Grafana**: Tüm verinin "orkestra şefi" (Görselleştirme).

## 🕵️ 2. Toplayıcı: Grafana Alloy
Eski tip `node_exporter`, `promtail` gibi 3-4 farklı ajan yerine sadece **Alloy** kullanacağız.
- **Avantajı**: Tek bir konfigürasyon (River dili) ile hem metrik hem log toplayabilmesi.
- **İçerik**: `prometheus.exporter.unix` bileşeni ile donanım metriklerini (CPU, RAM, Disk), `loki.source.docker` bileşeni ile container loglarını toplayacak.

## 🏷️ 3. Kritik Etiketleme (Labeling) Mimarisi
Görselleştirirken veriler arası geçiş yapabilmek için **Unified Labels (Birleşik Etiketler)** kullanacağız. Her bir veri (log veya metrik) şu etiketlere SAHİP OLACAK:

| Etiket Adı | Açıklama | Örnek |
| :--- | :--- | :--- |
| `host_name` | Verinin geldiği sunucu adı | `jenkins-srv`, `git-srv`, `k8s-worker` |
| `service_name` | Uygulama veya servis adı | `catalog-api`, `gitea`, `vault` |
| `env` | Çalışma ortamı | `local-lab` |

## 🎛️ 4. Değişken (Variables) Stratejisi
Grafana Dashboard'ların üst kısmında dinamik değişkenler kurgulanacak:
- **`$node` Değişkeni**: Prometheus'taki `label_values(host_name)` üzerinden güncellenecek.
- **`$service` Değişkeni**: Seçili node üzerindeki `label_values(service_name)` listesini getirecek.

**Sihirli Geçiş:** Bir Dashboard panelinde bir servis seçtiğinizde:
- **Metrik Paneli**: `node_cpu_usage{service_name="$service"}` sorgusunu çalıştıracak.
- **Log Paneli**: `{service_name="$service"}` Loki sorgusunu çalıştıracak.
Böylece log ve metrik zaman çizelgesinde **birbiriyle %100 örtüşecek.**

## ⚙️ 5. Alloy Yapılandırma Mantığı (River)
Alloy konfigürasyonunda `loki.relabel` kullanarak Docker Discovery'den gelen karmaşık isimleri (Örn: `/jenkins.1.fgh123`) temizleyip sade `service_name` etiketi üreteceğiz. Veriler merkezi `monitoring-srv` (192.168.2.87) adresine **Push** (Remote Write) yöntemiyle gönderilecek.

## 💾 6. Saklama ve Kaynak (Retention)
- **Metrik Saklama**: 15 gün.
- **Log Saklama**: 7 gün (Disk tasarrufu için).
- **Alloy Resource**: Her node'da minimal RAM kullanımı (Ajan başı <200MB).

---
**ANTIGRAVITY NOTU:** Bu yapı projenin sadece "çalıştığını" değil, "nasıl hissettiğini" de gerçek zamanlı görmemizi sağlayacak.
