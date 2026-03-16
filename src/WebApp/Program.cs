using eShop.WebApp.Components;
using eShop.ServiceDefaults;
// [DÜZELTME] Proxy başlıklarını (IP, Port, Protokol) işlemek için gerekli kütüphane.
using Microsoft.AspNetCore.HttpOverrides;

var builder = WebApplication.CreateBuilder(args);

builder.AddServiceDefaults();

builder.Services.AddRazorComponents().AddInteractiveServerComponents();

builder.AddApplicationServices();

// [DÜZELTME] Kubernetes/Traefik Reverse Proxy Yapılandırması
// Uygulamanın dış dünyadaki gerçek Host ve Port bilgilerini (eshop.local:80) tanımasını sağlar.
builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
    // X-Forwarded-For: Client IP
    // X-Forwarded-Proto: HTTP/HTTPS
    // X-Forwarded-Host: Gerçek Domain (eshop.local)
    options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto | ForwardedHeaders.XForwardedHost;
    
    // K3s/Kubernetes içinde proxy IP'leri sürekli değiştiği için tüm proxy geçişlerine güven.
    options.KnownIPNetworks.Clear();
    options.KnownProxies.Clear();
});

var app = builder.Build();

// [DÜZELTME] Tanımlanan Proxy başlıklarını HTTP istek hattında aktif et.
// Bu satır "Correlation Failed" hatasını çözen asıl tetikleyicidir.
app.UseForwardedHeaders();

app.MapDefaultEndpoints();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseAntiforgery();

// [DÜZELTME] UseHttpsRedirection KALDIRILDI. 
// Sistem HTTP üzerinden çalıştığı için SSL yönlendirmesi bağlantı hatasına yol açar.

app.UseStaticFiles();

app.MapRazorComponents<App>().AddInteractiveServerRenderMode();

app.MapForwarder("/product-images/{id}", "https+http://catalog-api", "/api/catalog/items/{id}/pic");

app.Run();
