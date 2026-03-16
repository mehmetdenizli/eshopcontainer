# Teknik Özet: OIDC Correlation Failed ve Proxy Çözümü

## Yapılan İşlem
eShopOnContainers projesinin Kubernetes Gateway API (Traefik 3.x) üzerine taşınması sonrası karşılaşılan "OIDC Correlation Failed" hatası, uygulama ve altyapı katmanında yapılan senkronize değişikliklerle çözülmüştür.

## Karşılaşılan Sorunlar
1. **Context Mismatch:** Uygulamanın (WebApp) bir reverse proxy (Traefik) arkasında çalışması nedeniyle, orijinal protokol (HTTP), host (eshop.local) ve port (80) bilgilerini doğru süzemediği tespit edildi.
2. **Port Uyuşmazlığı:** Traefik 8000 portunda dinlerken tarayıcı 80 portunu kullanıyordu. Bu durum OIDC `redirect_uri` adreslerinde tutarsızlığa yol açıyordu.
3. **Trust Issue:** ASP.NET Core, varsayılan olarak bilinmeyen proxy'lerden gelen başlıkları (X-Forwarded-*) reddediyordu.

## Kullanılan Kaynaklar
- **Altyapı:** Traefik Middleware (K8s Custom Resource)
- **Uygulama:** `Microsoft.AspNetCore.HttpOverrides` kütüphanesi ve `Program.cs` yapılandırması.

## Uygulanan Çözüm
- **WebApp/Program.cs:** Proxy başlıklarını kabul edecek şekilde güncellendi. `ASPNETCORE_FORWARDEDHEADERS_ENABLED` ile uyumlu hale getirildi. SSL (HTTPS) zorunluluğu (UseHttpsRedirection) yerel HTTP ortamı için kaldırıldı.
- **Traefik Middleware:** İstekleri uygulamaya iletirken portu zorunlu olarak `80` ve protokolü `http` olarak işaretleyen bir middleware (`eshop-headers`) oluşturuldu.
- **OIDC Configuration (Extensions.cs):**
    - **`ResponseMode = "query"`:** Cross-domain `POST` isteklerinde tarayıcının engellediği çerez sorununu aşmak için `GET` (Query) moduna geçildi.
    - **`SameSite=Lax` & `SecurePolicy=SameAsRequest`:** HTTP (non-TLS) ortamında korelasyon çerezlerinin düzgün taşınması sağlandı.
    - **Logout (SignOut) Rewrite:** Çıkış yaparken tarayıcıyı dahili `identity-api` yerine harici `identity.local` adresine yönlendiren event handler (`OnRedirectToIdentityProviderForSignOut`) eklendi.

## Sonuç
Kimlik doğrulama akışı (Login ve Logout) tarayıcı üzerinden uçtan uca doğrulanmıştır. ✅

## Bir Sonraki Adım
- [ ] Diğer mikroservislerin (Jenkins Pipeline imajları vb.) güncel kodlarla test edilmesi.
- [ ] Helm Chart hazırlığına geçiş.
