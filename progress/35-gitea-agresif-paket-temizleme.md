# Adım 35: Gitea Agresif Paket Temizleme ve Disk Yönetimi

Bu aşamada, kısıtlı disk alanını verimli kullanmak amacıyla Gitea Container Registry üzerinde "her mikroservis için sadece en son imajı tut" stratejisi uygulanmıştır.

## Teknik Detaylar
1. **Cron Yapılandırması:** Gitea'nın paket temizleme motoru standart 24 saatten **1 dakikaya** (`@every 1m`) indirildi.
2. **Global Temizlik Kuralları:** `app.ini` seviyesinde (Environment Variables) agresif temizlik aktif edildi:
    - `KEEP_LAST_VERSIONS=1`
    - `OLDER_THAN=0s`
    - `REMOVE_VERSIONS_MATCHING=(.*)`
3. **Web UI Entegrasyonu:** Kullanıcı/Organizasyon düzeyinde "Container" türü için temizlik kurallarının nasıl aktif edileceği test edildi ve doğrulandı.

## Kullanılan Kaynaklar
- **Gitea Config:** `ansible/templates/gitea/docker-compose.yml.j2`
- **Gitea API:** Paket versiyonlarını izleme ve doğrulama.
- **Ansible:** Ayarların `git-srv` (192.168.2.90) üzerine uygulanması.

## Sonuç
Yapılan testlerde (`test-cleanup:v1-v4`), sistemin yeni bir imaj pushlandıktan sonraki ilk 1 dakika içinde eski versiyonları otomatik olarak sildiği ve diskte sadece en güncel imajı bıraktığı kanıtlanmıştır.

## Sonraki Adımlar
1. Jenkins Pipeline'larındaki build sonrası imaj push adımlarının kontrol edilmesi.
2. Diğer mikroservisler (Catalog, Ordering vb.) için temizlik kurallarının devrede olduğunun periyodik takibi.

**Durum:** Tamamlandı ✅
