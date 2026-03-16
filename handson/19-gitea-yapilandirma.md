# Hands-on 19: Gitea & Container Registry Detaylı Yapılandırma Rehberi

Gitea sunucumuz (`git-srv | 192.168.2.90`) şu an tamamen sıfırlanmış, pırıl pırıl ve sizin ilk girişinizi bekleyen bir durumda. Bu doküman, kurulum sürecini ve projemiz için kritik olan **İmaj Tasarrufu** kurallarını detaylandırır.

## 🚀 1. Gitea İlk Kurulum (Şu Anki Durum: Temiz Sayfa)
Tarayıcınızdan `http://192.168.2.90:3000` adresine gittiğinizde Gitea sizi kurulum ekranıyla karşılayacaktır.

### 📍 Dikkat Edilmesi Gereken Ayarlar:
1. **Veritabanı Ayarları:** PostgreSQL bilgileri Ansible tarafından otomatik olarak yapılandırıldı. Lütfen bu kısımlara dokunmayın.
2. **Genel Ayarlar:** SSH portu `2222`, HTTP portu `3000` olarak sabitlenmiştir.
### 🔐 Güncel Giriş Bilgileri (Reset Sonrası):
- **URL:** [http://192.168.2.90:3000](http://192.168.2.90:3000)
- **Kullanıcı Adı:** `gitea`
- **Şifre:** `Eshop123!`
- **E-posta:** `foriinji@gmail.com`

## 💾 2. İmaj Tasarrufu: Paket Temizleme Kuralları (Keep 2)
Projemizde onlarca mikroservis sürekli build edileceği için disk alanını verimli kullanmak zorundayız. Gitea'nın paket temizleme özelliği, her imajın sadece son 2 sürümünü tutarak eski çöpleri temizler.

### 🛠️ Kuralı Aktif Etme Adımları:
1. Admin hesabınızla giriş yapın.
2. Sağ üstteki profil menüsünden **Site Yönetimi** (Site Administration) seçeneğine gidin.
3. Üst sekmelerden **Yapılandırma** (Configuration) sekmesini seçin.
4. Sol taraftaki menüden **Paketler** (Packages) başlığına tıklayın.
5. **Temizleme Kuralları** (Cleanup Rules) bölümünde "Kural Ekle" butonuna basın:
    - **Enabled:** İşaretli (On)
    - **Action:** En yenileri tut (Keep most recent)
    - **Keep Count:** **2** (Bu, her imaj için sadece son 2 sürümü saklar).
    - **Kapsam (Scope):** `.*` (Tüm paketleri kapsar).
6. "Kaydet" butonuna basarak kuralı sabitleyin.

> [!TIP]
> Gitea bu temizliği arka planda bir Cron job olarak her gece çalıştıracaktır.

## 🔑 3. Docker Registry Kullanımı
Gitea aynı zamanda bir Docker Registry olduğu için, mikroservis imajlarımızı buraya push edeceğiz.

### Giriş Yapma (Login):
```bash
docker login 192.168.2.90:3000
```
*Gitea kullanıcı adı ve şifrenizi girmeniz gerekecek.*

### İmaj Etiketleme (Tagging):
```bash
docker tag my-service:latest 192.168.2.90:3000/eshop/my-service:v1
```

## 🛠️ 4. Alternatif: Arka Plandan Admin Oluşturma (Yöntem B)
Eğer arayüzü kullanmadan hızlıca bir admin hesabı oluşturmak isterseniz (veya arayüze erişemezseniz) sunucu terminalinde şu profesyonel komutu kullanabilirsiniz:

```bash
# git-srv sunucusu üzerinde:
docker exec -u 1000 gitea gitea admin user create \
  --username my-admin \
  --password 'MySecretPass123' \
  --email admin@eshopcontainer.local \
  --admin
```

## 🌐 5. SSH & Git Erişimi
Gitea SSH portu `2222` olarak yapılandırılmıştır. Git komutlarını bu port üzerinden kullanmalısınız:

```bash
git clone ssh://git@192.168.2.90:2222/[kullanici]/[repo].git
```

## ⚠️ 6. Karşılaşılan Hatalar ve Şifre Sıfırlama

Eğer admin şifresini unutursanız veya kullanıcı adınızı kontrol etmeniz gerekirse, Ansible kontrol makinesinden (veya doğrudan `git.local` üzerinden) şu komutları kullanabilirsiniz:

### Kullanıcı Listesini Görme:
```bash
docker exec -u git gitea gitea admin user list
```

### Şifre Sıfırlama:
```bash
docker exec -u git gitea gitea admin user change-password \
  --username gitea \
  --password 'YeniSifre123!'
```

> **Önemli:** Komutu çalıştırırken `-u git` parametresi kritiktir. Gitea güvenlik gereği root kullanıcısı ile bu komutun çalıştırılmasına izin vermez.

### 🔑 7. Gitea Access Token
Proje otomasyonu ve Docker login işlemleri için oluşturulan erişim anahtarı:
- **Token:** `430bead450a6a1206922ca666587926faf53ddb2`

## 🐳 8. Uygulama İmajlarını Hazırlama ve Pushlama (Macbook Workflow)

Macbook üzerinden hazırladığınız imajları Gitea Container Registry'ye göndermek için bu akışı takip edin.

### 1. Registry Login:
```bash
docker login git.local:3000 -u gitea -p 430bead450a6a1206922ca666587926faf53ddb2
```

### 2. Mikroservis Build & Push Komutları:
Her servis için projenin kök dizininde şu komutları sırasıyla çalıştırın:

**Identity API:**
```bash
docker build -t git.local:3000/gitea/identity-api:latest -f src/Identity.API/Dockerfile .
docker push git.local:3000/gitea/identity-api:latest
```

**Catalog API:**
```bash
docker build -t git.local:3000/gitea/catalog-api:latest -f src/Catalog.API/Dockerfile .
docker push git.local:3000/gitea/catalog-api:latest
```

**Basket API:**
```bash
docker build -t git.local:3000/gitea/basket-api:latest -f src/Basket.API/Dockerfile .
docker push git.local:3000/gitea/basket-api:latest
```

**Ordering API:**
```bash
docker build -t git.local:3000/gitea/ordering-api:latest -f src/Ordering.API/Dockerfile .
docker push git.local:3000/gitea/ordering-api:latest
```

**WebApp (Frontend):**
```bash
docker build -t git.local:3000/gitea/webapp:latest -f src/WebApp/Dockerfile .
docker push git.local:3000/gitea/webapp:latest
```

> [!NOTE]
> İmaj yolları `gitea` kullanıcısı altında oluşturulacak şekilde güncellenmiştir (`git.local:3000/gitea/...`). Kubernetes manifestlerindeki imaj yolları buna göre senkronize edilmelidir.

---
**Önemli Not:** Gitea sıfırlandığı için bu ayarları bir kez yapmanız yeterlidir. Proje ilerledikçe bu merkez bizim tüm CI/CD süreçlerimizin kalbi olacak.
