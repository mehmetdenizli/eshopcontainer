# Hands-on: OIDC Correlation Failed Hatası Düzeltme Rehberi

Bu rehber, Traefik/Kubernetes arkasında çalışan .NET uygulamalarında OpenID Connect (OIDC) hatalarının nasıl giderileceğini adım adım açıklar.

## 1. Uygulama Katmanı (C# Değişiklikleri)

`src/WebApp/Program.cs` dosyasına şu bloklar eklenmelidir:

```csharp
using Microsoft.AspNetCore.HttpOverrides;

// Proxy başlıklarını kabul et
builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
    options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
    options.KnownIPNetworks.Clear();
    options.KnownProxies.Clear();
});

var app = builder.Build();

// Middleware'i aktif et
app.UseForwardedHeaders();

// SSL yoksa kaldırılmalı
// app.UseHttpsRedirection(); 
```

## 2. Altyapı Katmanı (Kubernetes/Traefik Değişiklikleri)

### Middleware Tanımı
`manifests/gateway/traefik-middlewares.yaml` dosyasını oluşturun:

```yaml
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: eshop-headers
  namespace: default
spec:
  headers:
    customRequestHeaders:
      X-Forwarded-Port: "80"
      X-Forwarded-Proto: "http"
```

### Rotalara Uygulama
`manifests/gateway/eshop-routes.yaml` dosyasında ilgili rotalara filtre ekleyin:

```yaml
      filters:
        - type: ExtensionRef
          extensionRef:
            group: traefik.io
            kind: Middleware
            name: eshop-headers
```

## 3. Komutlar

Değişiklikleri uygulamak için:

```bash
# Middleware oluştur
kubectl apply -f manifests/gateway/traefik-middlewares.yaml

# Rotaları güncelle
kubectl apply -f manifests/gateway/eshop-routes.yaml

# Uygulamayı yeniden başlat
kubectl rollout restart deployment webapp identity-api
```

## 4. Karşılaşılan Hatalar & Çözümler

| Hata | Sebep | Çözüm |
| :--- | :--- | :--- |
| **Correlation failed** | Port veya Protocol uyuşmazlığı. | X-Forwarded-Port: "80" middleware'i eklendi. |
| **Connection Refused** | HttpsRedirection aktif olması. | `app.UseHttpsRedirection()` pasif yapıldı. |
| **Bad Request (Identity)** | KnownProxies kısıtlaması. | `KnownProxies.Clear()` kodu eklendi. |
