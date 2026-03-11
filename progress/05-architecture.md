# eShop Architecture & Technologies Guide

Bu belge, eShop projesinin temel mimarisini, kullanılan teknolojileri ve bu teknolojilerin projede neden tercih edildiğini (bilmeyen birinin de anlayabileceği şekilde) açıklamak amacıyla hazırlanmıştır.

## 1. Genel Mimari: Mikroservisler (Microservices)

eShop uygulaması geleneksel (monolitik - tek parça) bir yapı yerine **Mikroservis Mimarisi** (Microservices Architecture) ile tasarlanmıştır.

**Mikroservis Nedir?**
Bir e-ticaret sitesini düşünün: Kullanıcı girişi, ürün kataloğu, alışveriş sepeti ve sipariş yönetimi gibi bölümleri vardır. Monolitik yapıda tüm bu kodlar tek bir projededir. Mikroservis mimarisinde ise her bir bölüm kendi başına, bağımsız çalışan, kendi veritabanı olan ufak birer programcık (servis) olarak tasarlanır.

**Neden Mikroservis Kullanılır?**
- **Bağımsız Ölçeklenebilirlik:** Örneğin "Black Friday" indirimlerinde sadece "Sepet" servisine çok yük binebilir. Tüm sistemi değil, sadece Sepet servisini (sunucu sayısını artırarak) güçlendirebiliriz.
- **Hata Yalıtımı:** Katalog servisi çökse bile, Sepet servisi çalışmaya devam edebilir. Tüm site çökmez.
- **Teknoloji Bağımsızlığı:** Bir servis C# ile yazılırken diğeri Python ile yazılabilir (Projeye özel).

## 2. Kullanılan Temel Teknolojiler

### .NET 9 & .NET Aspire (Orkestratör)
- **Nedir?** .NET 9, uygulamanın temel yazılım dilidir (C#). .NET Aspire ise mikroservisleri yöneten bir "orkestrasyon" aracıdır.
- **Neden Kullanıldı?** Mikroservisleri yerelde (bilgisayarımızda) ayağa kaldırmak normalde çok zordur; çünkü her servisi ayrı ayrı başlatmak, veritabanlarına bağlamak gerekir. `.NET Aspire`, `eShop.AppHost` projesi üzerinden "Bana Redis ver, Postgres ver, şu servisleri şu portlardan başlat ve birbirine bağla" diyerek tüm sistemi tek bir komutla (`dotnet run`) hatasız ve izlenebilir (Dashboard) şekilde ayağa kaldırır.

### Frontend (Kullanıcı Arayüzü) - WebApp (Blazor Server)
- **Nedir?** Müşterilerin tarayıcıdan (Chrome vb.) gördüğü asıl alışveriş ekranıdır. Projede `WebApp` adıyla geçer ve **Blazor Server** teknolojisi kullanır.
- **Neden Kullanıldı?** Geleneksel olarak frontend kısmı JavaScript (React, Vue vb.) ile yazılırken, Blazor sayesinde Microsoft geliştiricileri C# kullanarak interaktif web sayfaları yapabilir. Bu, backend ve frontend arasında kod paylaşımını (örneğin aynı sepet modelini) kolaylaştırır.

### Backend (Arka Plan Servisleri)
Yukarıda bahsettiğimiz iş parçacıklarıdır. Asıl işi yapan "Mutfak"tır.
- **`Identity.API`:** Kullanıcı kayıt, giriş ve şifre işlemlerini (OIDC formatında) sağlar.
- **`Catalog.API`:** Ürün isimlerini, fiyatlarını, resimlerini tutar ve listeler.
- **`Basket.API`:** Kullanıcının sepetindeki ürünleri anlık olarak hafızada tutar.
- **`Ordering.API` & `OrderProcessor`:** Müşteri siparişi tamamladığında bu siparişi veritabanına kaydeder ve ödeme/kargo adımlarına iletir.

## 3. Altyapı ve Veri Depolama Araçları

Mikroservislerin verilerini saklamak ve birbirleriyle haberleşmek için kullandıkları yan araçlardır. Docker konteynerleri olarak çalışırlar.

### PostgreSQL (İlişkisel Veritabanı)
- **Nedir?** Klasik tablolar (Satırlar ve Sütunlar) halinde veri saklayan çok güçlü bir veritabanıdır.
- **Neden Kullanıldı?** Kalıcı ve hassas veriler için kullanılır. eShop projesinde `IdentityDb` (Kullanıcılar), `CatalogDb` (Ürünler) ve `OrderingDb` (Siparişler) gibi tablolar halinde tutulması gereken veriler PostgreSQL üzerinde saklanır.

### Redis (Önbellek ve Hızlı Depolama)
- **Nedir?** Verileri hard disk yerine anlık olarak bilgisayarın RAM'inde (belleğinde) saklayan inanılmaz hızlı bir veritabanı türüdür (Key-Value mağazası).
- **Neden Kullanıldı?** eShop projesinde **`Basket.API` (Sepet)** verileri Redis'te tutulur. Çünkü kullanıcılar sepete sık sık ürün ekler veya çıkarır; bu işlemlerin çok hızlı ve anlık olması gerekir. Sepet kalıcı değil geçici bir veri olduğu için Redis bunun için dünyadaki en ideal araçtır.

### RabbitMQ (Mesaj Kuyruğu / Message Broker)
- **Nedir?** Mikroservislerin birbirleriyle konuşmasını sağlayan bir "Postacı" uygulamasıdır.
- **Neden Kullanıldı?** Diyelim ki müşteri "Sipariş Ver" butonuna bastı. `Ordering.API` siparişi alır, kaydeder ve RabbitMQ'ya bir mesaj bırakır: *"Sipariş alındı, stoku düş ve ödemeyi çek"*. `Catalog.API` (stok için) ve `PaymentProcessor` (ödeme için) bu postacıyı dinler, mesajı aldıklarında kendi işlerini yaparlar.
- **Avantajı:** Servisler birbirine doğrudan bağımlı (bekliyor) olmaz. Ödeme servisi anlık olarak çökse bile, ayağa kalktığında RabbitMQ'daki bekleyen mesajı okur ve işlemine kaldığı yerden devam eder. Hiçbir sipariş kaybolmaz.

## Özet Akış Senaryosu

1. Müşteri tarayıcıya girer (`WebApp`).
2. Giriş yapmak ister, sistem onu `Identity.API`'ye (Postgres tabanlı) yönlendirir. Giriş yapıp geri gelir.
3. Ürünlere bakar (`Catalog.API` -> Postgres).
4. Ürünü sepete ekler (`Basket.API` -> Redis).
5. Siparişi tamamlar (`Ordering.API` -> Postgres -> **RabbitMQ** mesajı).
6. RabbitMQ üzerinden mesajı alan `OrderProcessor` ve `PaymentProcessor` arka planda ürün stoklarını düşer ve karttan çekim yapar.

Bu mimari sayesinde eShop, milyonlarca anlık kullanıcıyı taşıyabilecek, Amazon, Trendyol gibi devlerin kullandığı standartlara sahip bir projedir.
