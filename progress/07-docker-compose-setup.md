# Traditional Dockerization: Setup & Execution Guide

Bu belge, projeye yeni eklediğimiz "Geleneksel Docker" yaklaşımını (Dockerfile ve docker-compose) detaylandırmaktadır. Proje, yerel geliştirme için .NET Aspire'ı desteklemeye devam ederken, artık saf Docker araçlarıyla da ayağa kaldırılabilir hale gelmiştir.

## Neler Yaptık?

1. **Dockerfile'ların Eklenmesi:**
   Aşağıdaki 5 temel projenin kök dizinine, standart .NET 9 multi-stage (çok aşamalı) `Dockerfile`'ları eklendi:
   - `src/Identity.API/Dockerfile`
   - `src/Catalog.API/Dockerfile`
   - `src/Basket.API/Dockerfile`
   - `src/Ordering.API/Dockerfile`
   - `src/WebApp/Dockerfile`

   *Not: Bu Dockerfile'lar, `dotnet restore` işleminin projedeki `Shared` ve `eShop.ServiceDefaults` gibi bağımlılıkları doğru çözebilmesi için projenin **kök (root) dizininden** tetiklenmek zorundadır.*

2. **`docker-compose.yml` Dosyasının Oluşturulması:**
   Proje ana dizinine, tüm servisleri ağda birleştiren bir orchestrator dosyası eklendi. Bu dosya:
   - Altyapı servislerini (`postgres`, `redis`, `rabbitmq`) resmi imajlarından port eşlemeleriyle ayağa kaldırır.
   - Bizim .NET servislerimizi yukarıdaki Dockerfile'lardan derler.
   - Tüm `ConnectionStrings` ve `ASPNETCORE_ENVIRONMENT` gibi değişkenleri ayarlayarak mikroservislerin birbirleriyle konuşabilmesini sağlar.

## Geleneksel Yöntemle Çalıştırma Adımları

.NET Aspire'dan (veya Visual Studio'dan) bağımsız olarak, sadece Docker kurulu bir makinede uygulamayı ayağa kaldırmak için şu komutları kullanabilirsiniz:

### 1. İmajları Derleme ve Konteynerleri Başlatma
Projenin kök dizininde (yani `docker-compose.yml`'ın olduğu yerde) terminal açın:

```bash
docker-compose up --build -d
```
- `--build`: Tüm .NET kodlarının Dockerfile'lara göre en baştan (sıfırdan) derlenmesini sağlar.
- `-d` (Detached): Logları terminale basarak terminalinizi kilitlemek yerine, konteynerleri arka planda sessizce başlatır.

### 2. Uygulamayı Test Etme
Docker compose komutu bittiğinde ve konteynerler sağlıklı "running" durumuna geçtiğinde:
- **WebApp (Ana Site):** `http://localhost:5100` üzerinden ulaşabilirsiniz.
- **Identity API:** `http://localhost:5243`

*Bağlantı Notu:* Aspire kullanmadığımız için Aspire Dashboard (19888 portu) bu yöntemde çalışmaz; çünkü bu tamamen saf ve manuel bir Docker ortamıdır.

### 3. Sistemi Kapatma (Durdurma)
İşiniz bittiğinde tüm konteynerleri silmek ağları temizlemek için:

```bash
docker-compose down
```

## Hybrid Stratejinin Sonucu
Artık proje, developer konforu için `dotnet run` (Aspire) ile, production/CI-CD senaryoları simülasyonu için ise `docker-compose up` ile güvenle kullanılabilen çok yönlü bir mimariye sahiptir.

## Bilinen Sorunlar ve Çözümleri (Troubleshooting)

### ARM64 (Apple Silicon) Üzerinde Grpc.Tools Segmentation Fault (Hata Kodu: 139)
.NET 10 (Debian/Linux) altyapısında Docker imajları derlenirken, `Grpc.Tools` kütüphanesinin içerisindeki varsayılan `protoc` (Protocol Buffers Compiler) aracı, Linux ARM64 mimarisinde bellek hatası (Segmentation Fault) vermektedir.

Bu sorunu kalıcı olarak çözmek için tüm `Dockerfile` dosyalarında Microsoft'un paketinden gelen `protoc` yerine, işletim sisteminin kendi (native) Derleyicisi kurulmuş ve sisteme entegre edilmiştir:
```dockerfile
# Sistem derleyicisinin kurulması
RUN apt-get update && apt-get install -y protobuf-compiler

# MSBuild (dotnet publish) sırasında sisteme yönlendirilmesi
RUN dotnet publish -c Release -o /app/publish -p:Protobuf_ProtocFullPath=/usr/bin/protoc
```
