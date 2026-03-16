# Gitea Container Paket Temizleme (Cleanup) Rehberi

Bu rehber, Gitea Container Registry üzerindeki Docker imajlarının diskte yer kaplamaması için nasıl temizleneceğini adım adım açıklar. Özellikle "her paketin sadece son sürümünü tut" kuralı hedeflenmiştir.

## 1. Altyapı Yapılandırması (Agresif Cron)

Gitea'yı varsayılan 24 saatlik yerine dakikalık temizlik yapmaya zorlamak için `docker-compose.yml` veya `Environment Variables` kısmına şu ayarlar eklenmelidir:

```yaml
# ansible/templates/gitea/docker-compose.yml.j2 (veya app.ini)
- GITEA__packages__ENABLED=true
- GITEA__packages__CLEANUP_ENABLED=true
- GITEA__packages__CLEANUP_RULE_ENABLED=true

# Paket başı en son 1 versiyonu sakla
- GITEA__packages_0X2E_cleanup__KEEP_LAST_VERSIONS=1
- GITEA__packages_0X2E_cleanup__OLDER_THAN=0s
- GITEA__packages_0X2E_cleanup__REMOVE_VERSIONS_MATCHING=(.*)

# Temizlik görevini her 5 dakikada bir çalıştır
- GITEA__cron_0X2E_package_cleanup__ENABLED=true
- GITEA__cron_0X2E_package_cleanup__SCHEDULE=@every 5m
```

## 2. Web UI Ayarları (Zorunlu)

Global ayarlar yapılmış olsa bile, temizliğin kesin çalışması için Gitea Web arayüzünde "Container" türü için kural aktif edilmelidir:

1. Gitea'ya giriş yapın ve ilgili **Organizasyon/Kullanıcı Ayarları**'na (Settings) gidin.
2. Sol menüden **Paketler (Packages)** sekmesini ve ardından **Temizleme Kuralları (Cleanup Rules)**'nı seçin.
3. **Yeni Kural Ekle (Add Rule)** deyin:
    * **Aktifleştirilmiş:** [X]
    * **Tür (Type):** `Container` (En kritik kısım, Alpine seçmeyin!)
    * **Deseni tüm paket adına uygula:** [X]
    * **En sonuncuyu sakla:** `Paket başına 1 sürüm`
    * **Şundan eski sürümleri kaldır:** `0 days`
    * **Eşleşen sürümleri kaldır:** `.*` (RegEx ile tüm versiyonları kapsar)
4. **Kaydet** butonuna basın.

## 3. Doğrulama ve Test Adımları

Temizliğin çalışıp çalışmadığını şu komutlarla test edebilirsiniz:

```bash
# 1. Test imajı pushlayın (Birkaç versiyon)
docker tag my-app:latest git.local:3000/gitea/my-app:v1 && docker push git.local:3000/gitea/my-app:v1
docker tag my-app:latest git.local:3000/gitea/my-app:v2 && docker push git.local:3000/gitea/my-app:v2

# 2. Gitea Loglarını izleyin (Temizlik tetiklendi mi?)
ansible git -i inventory/hosts.ini -m shell -a "docker logs gitea" -b

# 3. Kalan versiyonları listeleyin
curl -u <user>:<pass> -s http://git.local:3000/api/v1/packages/gitea | jq -r '.[].version'
```

### Karşılaşılan Hatalar ve Çözümleri
- **"Eşleşen paket bulunamadı":** Tür kısmında `Alpine` seçilidir. `Container` olarak güncelleyin.
- **"Hemen silinmiyor":** `OLDER_THAN` parametresi `0s` (veya Web UI üzerinden `0 days`) olarak ayarlanmamıştır. Varsayılan 30 gündür.

---
**Disk Durumu Notu:** _Bu yapılandırma ile disk alanınız sadece aktif çalışan imajlar kadar kullanılacaktır._
