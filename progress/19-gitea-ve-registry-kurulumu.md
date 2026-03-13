# Adım 19: Gitea ve Container Registry Kurulumu

Bu aşamada, projenin hem Git sunucusu hem de Container Registry altyapısı olarak kullanılacak olan Gitea kurulumu gerçekleştirilmiştir.

## Teknik Detaylar
1. **Kurulum Tipi:** Docker Compose (git-srv üzerinde bağımsız servis olarak).
2. **Veritabanı:** PostgreSQL 15 (Alpine).
3. **Hizmetler:**
    - **Git Hosting:** Tüm projenin kaynak kodlarını yerelde saklayacak.
    - **Package Registry:** Mikroservislerin Docker imajlarını (OCI) depolayacak.
4. **Dinamik Yapılandırma:** Gitea `app.ini` ayarları, konteyner başlatılırken çevre değişkenleri (environment variables) ile otomatik olarak yapılandırılmış ve "Package Registry" özelliği aktif edilmiştir.

## İmaj Temizleme Stratejisi
Kullanıcı isteği doğrultusunda, disk alanını verimli kullanmak için "En Yeni 2 İmajı Tut" kuralı için altyapı hazırlanmıştır:
- `GITEA__packages__CLEANUP_RULE_ENABLED=true` parametresi ile temizlik motoru aktif edildi.
- **Manuel Adım:** İlk kurulumdan sonra admin panelinde "Package Cleanup Rules" (Paket Temizleme Kuralları) aktif edilmelidir (Rehberde detaylandırıldı).

## Erişim Bilgileri
- **Gitea URL:** `http://192.168.2.90:3000` (git.local)
- **SSH Port:** `2222`

## Sonraki Adımlar
1. Admin hesabı oluşturulması ve organizasyon yapısının kurulması.
2. Jenkins kurulumu ve Gitea entegrasyonu.
3. Docker Registry için login testleri.

**Devam edeyim mi?**

ONAY BEKLENİYOR
