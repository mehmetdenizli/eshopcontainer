# Adım 23: Monitoring Stratejisi (PLGA + Alloy)

Bu aşamada projenin "Sinir Sistemi" olan İzlenebilirlik (Observability) altyapısı kurulmuştur.

## 🧠 Karar Verme Süreci (Neden PLGA?)
Altyapı tasarımı sırasında **ELK Stack** ve **PLGA (Prometheus-Loki-Grafana-Alloy)** arasında bir değerlendirme yapılmıştır:

| Özellik | ELK Stack | PLGA Stack (Seçilen) |
| :--- | :--- | :--- |
| **Kaynak Tüketimi** | Yüksek (Min 6-8GB RAM) | Düşük (2GB RAM ile tıkır tıkır) |
| **Log Yönetimi** | Çok Güçlü (Full-text search) | Verimli (Index-based) |
| **Metrik Yönetimi** | Orta Seviye | Üst Seviye (Endüstri Standardı) |
| **Tek Ekran Birleşimi** | Kibana (Sadece Log/Metrics) | Grafana (Log + Metrics + Tracing) |

**Karar:** Mevcut 24GB RAM limitimizi en verimli şekilde kullanmak ve hem log hem metrikleri tek bir modern arayüzde (Grafana) toplamak için **PLGA + Alloy** yapısında karar kılınmıştır.

## 🎯 Vizyon: "Single Pane of Glass" (Birleşik İzleme Ekranı)
Bu stratejinin hedefi, bir sistem hatası olduğunda (Örn: `catalog-api` çöktüğünde), hem CPU/RAM grafiklerini hem de hata loglarını **tek bir saniyede** ve **tek bir ekranda** birleşik olarak görebilmektir.

## 🏗️ Mimari Yapı (PLG Stack)
1. **Grafana Alloy (Collector):** Tüm sunucular (7 adet) üzerinde ajan olarak çalışır. Docker logs, Node metrics ve K8s verilerini toplayarak merkezi sunucuya iletir.
2. **Prometheus (Metrik Depo):** Sayısal verilerin (CPU, RAM, Hata Oranları) zamana bağlı saklandığı veritabanı.
3. **Loki (Log Depo):** Uygulama ve sistem loglarının indekslenerek saklandığı verimli log motoru.
4. **Grafana (Görselleştirme):** Tüm verilerin Dashboard'lar üzerinde anlamlandırıldığı ana kule.

## 🏷️ Etiketleme (Labeling) Mimarisi
Görselleştirirken performans kaybını önlemek için **Default Labels (Varsayılan Etiketler)** kullanılacaktır. Gereksiz `relabel` işlemleri kaldırılarak sistem performansı optimize edilmiştir.

| Etiket Adı | Açıklama | Örnek |
| :--- | :--- | :--- |
| `instance` | Verinin geldiği sunucu adı | `jenkins.local`, `git.local`, `k3s-master` |
| `job` | Verinin kaynağı | `integrations/unix`, `integrations/cadvisor`, `kubernetes-pods` |
| `container` | Docker konteyner adı | Discovery tarafından otomati atanır |

## ⚙️ Alloy Yapılandırma Mantığı (River)
Alloy konfigürasyonunda karmaşık `relabel` işlemleri yerine, Docker ve K8s Discovery servislerinin sağladığı ham metadata kullanılmaktadır. Veriler merkezi `monitoring-srv` (192.168.2.87) adresine **Push** (Remote Write) yöntemiyle gönderilmektedir.

## 💾 Saklama ve Kaynak (Retention)
- **Metrik Saklama**: 15 gün.
- **Log Saklama**: 7 gün (Disk tasarrufu için).
- **Alloy Resource**: Her node'da minimal RAM kullanımı (Ajan başı <200MB).

---
**ANTIGRAVITY NOTU:** Bu yapı projenin sadece "çalıştığını" değil, "nasıl hissettiğini" de gerçek zamanlı görmemizi sağlayacak.
