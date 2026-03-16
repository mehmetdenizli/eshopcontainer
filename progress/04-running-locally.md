# Running eShop Locally

Bu belge, eShop uygulamasının yerel ortamda (.NET Aspire ile) ayağa kaldırılması ve karşılaşılan ilk hataların çözümlerini içerir.

## 1. Uygulamayı Başlatma

Uygulamanın orkestrasyonunu (tüm servislerin ve veritabanlarının tek noktadan yönetimini) `.NET Aspire` sağlamaktadır. Projeyi çalıştırmak için ana dizinden aşağıdaki komut kullanılır:

```bash
dotnet run --project src/eShop.AppHost/eShop.AppHost.csproj
```

Bu komut:
- Tüm Docker konteynerlerini (Postgres, Redis, RabbitMQ) başlatır.
- Tüm backend servislerini (Identity, Catalog, Basket, Ordering) yapılandırır.
- Web uygulamalarını (WebApp) derler ve çalıştırır.
- Tüm kaynakların tek ekrandan izlenebileceği **Aspire Dashboard**'u aktif eder.

## 2. SSL Sertifika Hatası ve Çözümü

Dashboard'u ilk açtığımızda veya WebApp üzerinden `Identity.API`'ye bağlanmaya çalıştığımızda, tarayıcının veya gRPC'nin lokal sertifikalara güvenmemesinden dolayı **`UntrustedRoot`** hatası alınır ve sayfa sonsuz yükleme (loading) durumunda kalır.

**Çözüm:**
.NET lokal geliştirme sertifikalarının sisteme güvenilir olarak eklenmesi gerekir. Terminal üzerinden şu komut çalıştırılır:

```bash
dotnet dev-certs https --trust
```

Kurulum sırasında işletim sistemi (macOS) yönetici izni isteyecektir. Başarılı olduktan sonra uygulama yeniden başlatıldığında SSL sorunu ortadan kalkar.

## 3. WebApp Login Yönlendirme Hatası (Blazor Enhanced Nav)

**Sorun:**
Sertifika hatası çözülmesine rağmen "Giriş Yap" (Login) butonuna tıklandığında uygulamanın sayfa değiştirmemesi.

**Nedeni:**
Blazor'ın "Enhanced Navigation" (Sayfa yenilemeden sadece içeriği değiştirme) özelliği açık olduğu için, OIDC (Identity) provider'ının bulunduğu başka bir domaine (port) tam sayfa yönlendirmesi yapılıyorken CORS engeline takılması.

**Çözüm:**
`src/WebApp/Components/Layout/UserMenu.razor` dosyasındaki Login linkine **`data-enhance-nav="false"`** niteliği eklenerek, Blazor'ın bu bağlantıyı "eski usül" tam sayfa (full reload) olarak açması sağlandı.

```html
<a aria-label="Sign in" href="@Pages.User.LogIn.Url(Nav)" data-enhance-nav="false">
    <img role="presentation" src="icons/user.svg" />
</a>
```

## 4. Login Butonu CSS Sorunu

**Sorun:**
`Identity.API` projesindeki "Login" butonunun orijinal (Microsoft) CSS'inde simsiyah ve çok büyük olarak tasarlanmış olması sebebiyle okunaksız görünmesi.

**Çözüm:**
`src/Identity.API/wwwroot/css/site.css` dosyası güncellenerek butonun rengi eShop-Yeşili (`#83D01B`) olarak değiştirildi, metin rengi beyaz yapıldı ve etkileşim (hover) efekti eklendi.

```css
.login-container .btn.btn-primary {
    background: #83D01B;
    color: white;
    border: none;
    font-weight: bold;
    cursor: pointer;
}

.login-container .btn.btn-primary:hover {
    background: #6ba616;
    color: white;
}
```

## Son Durum
Sistem eksiksiz ve test edilebilir bir biçimde çalışmaktadır ve `Identity` servisindeki geliştirmeler `dev` branch'inde mevcuttur.
