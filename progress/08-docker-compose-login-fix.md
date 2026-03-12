# Docker Compose OIDC Login Fix

Bu doküman, Docker Compose ortamında karşılaşılan OIDC (OpenID Connect) login sorununu ve uygulanan teknik çözümü açıklamaktadır.

## Sorun Analizi

Standart bir Docker Compose kurulumunda servisler birbirlerine container adları (örneğin `http://identity-api:8080`) üzerinden erişirler. Ancak OIDC login akışında üç farklı taraf yer alır:

1. **WebApp Container**: Sunucu tarafında token doğrulaması yapar.
2. **Identity.API Container**: Kimlik doğrulama sunucusudur.
3. **Tarayıcı (Browser)**: Kullanıcının fiziksel makinesinde (Mac/Windows) çalışır.

### Çakışma Noktası
Docker iç ağındaki bir URL (`http://identity-api:8080`), tarayıcı tarafından çözümlenemez. Tersine, tarayıcının erişebildiği bir URL (`http://localhost:5243`), `webapp` container'ı içinden erişilemez (çünkü container içinde `localhost` kendisini temsil eder).

OIDC protokolü, güvenlik gereği discovery document (`.well-known/openid-configuration`) içindeki `issuer` ve `endpoint` URL'lerinin tutarlı olmasını bekler.

## Neden .NET Aspire'da Sorun Yoktu?

.NET Aspire, tüm servisleri host makine üzerinde `localhost` portları üzerinden orkestre eder. Hem tarayıcı hem de servislerin kendisi aynı `localhost` adresini kullandığı için URL uyuşmazlığı yaşanmaz.

## Uygulanan Çözüm: `IdentityUrlExternal` Pattern

Sorunu çözmek için hem iç ağ (internal) hem de dış ağ (external) URL'lerini destekleyen esnek bir yapı kuruldu.

### 1. WebApp: Dinamik URL Değişimi (`Extensions.cs`)

`WebApp/Extensions/Extensions.cs` dosyasında `AddAuthenticationServices` metoduna şu mantık eklendi:

- `IdentityUrl`: Sunucunun (WebApp) Discovery Doc ve Token exchange için kullanacağı iç adres.
- `IdentityUrlExternal`: Tarayıcının Login sayfası için kullanacağı dış adres.

```csharp
options.Events = new OpenIdConnectEvents
{
    OnRedirectToIdentityProvider = context =>
    {
        // Tarayıcıya 302 Redirect gönderilmeden hemen önce, 
        // internal URL'yi tarayıcının erişebileceği external URL ile değiştirir.
        context.ProtocolMessage.IssuerAddress = context.ProtocolMessage.IssuerAddress
            .Replace(identityUrl, identityUrlExternal, StringComparison.OrdinalIgnoreCase);
        return Task.CompletedTask;
    }
};
```

### 2. Identity.API: Sabit Issuer Tanımı (`Program.cs`)

IdentityServer discovery dokümanının her koşulda tarayıcıyla uyumlu `issuer` bilgisini döndürmesi için `IssuerUri` yapılandırması aktif edildi:

```csharp
builder.Services.AddIdentityServer(options =>
{
    options.IssuerUri = builder.Configuration["IssuerUri"]; // Env var üzerinden set edilir
    // ...
})
```

### 3. Docker Compose Yapılandırması

`docker-compose.yml` üzerinde ilgili environment değişkenleri tanımlandı:

- `webapp` servisi için:
    - `IdentityUrl=http://identity-api:8080`
    - `IdentityUrlExternal=http://localhost:5243`
- `identity-api` servisi için:
    - `IssuerUri=http://localhost:5243`

## Aspire Uyumluluğu

Yapılan değişiklikler tamamen geriye dönük uyumludur:
- `IdentityUrlExternal` veya `IssuerUri` değişkenleri tanımlanmazsa (Aspire senaryosu), kod otomatik olarak varsayılan `IdentityUrl` değerini kullanır.
- Bu sayede uygulama hem Aspire AppHost ile hem de geleneksel Docker Compose ile hiçbir kod değişikliği gerektirmeden çalışabilir.
