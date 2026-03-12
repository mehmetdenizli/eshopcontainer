# .NET Aspire Açılış Kararlılığı (Startup Resilience)

Bu doküman, mikroservislerin inicializasyon aşamasında karşılaştığı "yarış durumlarını" (race condition) ve bunları çözmek için uyguladığımız teknikleri açıklar.

## Sorun: Yarış Durumu (Race Condition)

.NET Aspire tüm servisleri aynı anda başlatmaya çalışır. Bu durum şu soruna yol açıyordu:
1. Postgres konteynerı saniyeler içinde "Running" durumuna geçer.
2. Ancak Postgres içindeki veritabanı motorunun bağlantı kabul etmeye hazır olması biraz daha uzun sürer.
3. Mikroservisler (Identity, Catalog vb.) hemen bağlanıp `MigrateAsync()` yapmaya çalıştığında "Connection Refused" hatası alarak kapanıyorlardı.

## Uygulanan Çözümler

Bu sorunu çözmek için iki katmanlı bir direnç (resilience) yapısı kurduk:

### 1. Aspire Orkestrasyon Seviyesi (.WaitFor)
`eShop.AppHost/Program.cs` içinde, mikroservislerin veritabanları tam hazır olmadan başlamasını engelleyen bağımlılıklar tanımladık.

```csharp
var identityApi = builder.AddProject<Projects.Identity_API>("identity-api")
    .WithReference(identityDb)
    .WaitFor(identityDb); // Veritabanı sağlıklı sinyal verene kadar bekle
```

### 2. Uygulama Seviyesi (Migration Delay)
`Shared/MigrateDbContextExtensions.cs` içinde, veritabanı bağlantısı kurulmadan önce kısa bir bekleme süresi ve daha detaylı hata loglaması ekledik.

```csharp
// DbContextMigration içinde:
await Task.Delay(2000); // Veritabanına "nefes alma" süresi tanı
var strategy = context.Database.CreateExecutionStrategy();
await strategy.ExecuteAsync(() => InvokeSeeder(...));
```

## Sonuç
Bu düzenlemeler sayesinde:
- Servislerin rastgele çökmesi (kırmızı "Finished" durumu) engellendi.
- Aspire'ın kendi kendini iyileştirme (self-healing) mekanizması üzerindeki yük azaltıldı.
- İlk kurulum (seed verilerinin yazılması) çok daha güvenilir hale getirildi.
