# Hands-on 19: Gitea & Container Registry Detaylı Yapılandırma Rehberi

Gitea sunucumuz (`git-srv | 192.168.2.90`) şu an tamamen sıfırlanmış, pırıl pırıl ve sizin ilk girişinizi bekleyen bir durumda. Bu doküman, kurulum sürecini ve projemiz için kritik olan **İmaj Tasarrufu** kurallarını detaylandırır.

## 🚀 1. Gitea İlk Kurulum (Şu Anki Durum: Temiz Sayfa)
Tarayıcınızdan `http://192.168.2.90:3000` adresine gittiğinizde Gitea sizi kurulum ekranıyla karşılayacaktır.

### 📍 Dikkat Edilmesi Gereken Ayarlar:
1. **Veritabanı Ayarları:** PostgreSQL bilgileri Ansible tarafından otomatik olarak yapılandırıldı. Lütfen bu kısımlara dokunmayın.
2. **Genel Ayarlar:** SSH portu `2222`, HTTP portu `3000` olarak sabitlenmiştir.
3. **Yönetici Hesabı Oluşturma (KRİTİK):** Sayfanın en altındaki **"Yönetici Hesabı Ayarları"** (Administrator Account Settings) bölümünü açın ve kendi özel kullanıcı adınızı ve şifrenizi tanımlayın.
    - *Not: Eğer burada hesap oluşturmazsanız, ilk kayıt olan kullanıcı otomatik olarak admin olur.*

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

---
**Önemli Not:** Gitea sıfırlandığı için bu ayarları bir kez yapmanız yeterlidir. Proje ilerledikçe bu merkez bizim tüm CI/CD süreçlerimizin kalbi olacak.

**Devam edebilir miyiz?**

ONAY BEKLENİYOR
