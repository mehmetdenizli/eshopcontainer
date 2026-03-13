# Adım 21: SonarQube ve Güvenlik (Trivy) Entegrasyonu

Bu aşamada projenin kod kalitesini, güvenliğini ve konteyner açıklarını denetleyecek olan altyapı kurulmuştur.

## Teknik Bileşenler
1. **SonarQube Sunucusu:**
    - `security-srv` (192.168.2.91) üzerinde Docker Compose ile yapılandırıldı.
    - PostgreSQL 15 veritabanı ile kalıcı veri saklama sağlandı.
    - **OS Optimizasyonu:** Elasticsearch motorunun sağlıklı çalışması için `vm.max_map_count` değeri `262144` seviyesine artırıldı ve dosya limitleri güncellendi.
2. **Trivy (Security Scanner):**
    - `jenkins-srv` makinesine doğrudan bir binary/paket olarak kuruldu.
    - Mikroservislerin Docker imajları push edilmeden önce saniyeler içinde güvenlik taramasından geçirilebilecek.

## Entegrasyon Detayları
- **Jenkins & SonarQube:** Jenkins tarafında `sonar` eklentisi zaten kurulu. Artık Jenkins, build edilen kodu analiz için bu sunucuya gönderebilir.
- **Güvenlik Kapısı (Quality Gate):** Pipeline'lara eklenecek olan SonarQube ve Trivy basamakları sayesinde, kritik hata veya güvenlik açığı barındıran kodların Kubernetes'e canlıya çıkması engellenecek.

## Erişim Bilgileri
- **SonarQube URL:** `http://192.168.2.91:9000`
- **Varsayılan Giriş:** `admin` / `admin` (İlk girişte şifre değişikliği zorunludur).

---
**ANTIGRAVITY NOTU:** Artık eShopOnContainers kodlarını sadece "çalıştırmak" değil, aynı zamanda "güvenli ve kaliteli" olduğundan emin olarak yayına alabileceğiz.
