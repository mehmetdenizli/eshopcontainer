# Adım 23: Monitoring Stratejisi (PLGA Stack) ve Gözlem Kulesi

Bu aşamada projenin "Sinirsistemi" olan İzlenebilirlik (Observability) altyapısı kurulmuştur. 

## 🧠 Karar Verme Süreci (Neden PLGA?)
Altyapı tasarımı sırasında **ELK Stack** ve **PLGA (Prometheus-Loki-Grafana-Alloy)** arasında bir değerlendirme yapılmıştır:

| Özellik | ELK Stack | PLGA Stack (Seçilen) |
| :--- | :--- | :--- |
| **Kaynak Tüketimi** | Yüksek (Min 6-8GB RAM) | Düşük (2GB RAM ile tıkır tıkır) |
| **Log Yönetimi** | Çok Güçlü (Full-text search) | Verimli (Index-based) |
| **Metrik Yönetimi** | Orta Seviye | Üst Seviye (Endüstri Standardı) |
| **Tek Ekran Birleşimi** | Kibana (Sadece Log/Metrics) | Grafana (Log + Metrics + Tracing) |

**Karar:** Mevcut 24GB RAM limitimizi en verimli şekilde kullanmak ve hem log hem metrikleri tek bir modern arayüzde (Grafana) toplamak için **PLGA + Alloy** yapısında karar kılınmıştır.

## 🏗️ Mimari Yapı
1. **Grafana Alloy (Collector):** Tüm sunucular (7 adet) üzerinde ajan olarak çalışır. Docker logs, Node metrics ve K8s verilerini toplayarak merkezi sunucuya iletir.
2. **Prometheus (Metrik Depo):** Sayısal verilerin (CPU, RAM, Hata Oranları) zamana bağlı saklandığı veritabanı.
3. **Loki (Log Depo):** Uygulama ve sistem loglarının indekslenerek saklandığı verimli log motoru.
4. **Grafana (Görselleştirme):** Tüm verilerin Dashboard'lar üzerinde anlamlandırıldığı ana kule.

## 🏷️ Etiketleme ve Değişken Mimarisi
Verilerin "çöplüğe" dönüşmemesi için Alloy seviyesinde şu dinamik etiketler (labels) kurgulanmıştır:
- `env`: `local-lab`
- `node`: Sunucu adı (jenkins-srv, git-srv vb.)
- `service`: Servis/App adı (catalog-api, ordering-api vb.)
- `severity`: Log seviyesi (info, error, critical)

---
**ANTIGRAVITY NOTU:** Bu yapı projenin sadece "çalıştığını" değil, "nasıl hissettiğini" de görmemizi sağlayacak.
