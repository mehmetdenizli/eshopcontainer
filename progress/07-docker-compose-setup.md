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

### Grpc.Tools Segmentation Fault (Hata Kodu: 139) ve Mimari Farklılıkları

.NET 10 (Debian tabanlı) Linux Docker imajları derlenirken, eShop içerisindeki mikroservislerin birbirleriyle iletişim kurmasını sağlayan gRPC altyapısına ait `Grpc.Tools` isimli kütüphanenin derleyicisi (`protoc` - Protocol Buffers Compiler), projemizi ayağa kaldırmaya çalışırken bir bellek hatası (Segmentation Fault - Exit Code 139) verdi.

#### 1. Neden Bu Hatayla Karşılaştık?
Bu hatanın temel sebebi **işlemci mimarisindeki (CPU Architecture) farklılıklar**dır:
- Geliştirme yaptığınız bilgisayar bir **Mac (Apple Silicon)**, yani **ARM64** işlemci mimarisine sahip.
- Docker üzerinde çalıştırdığımız imajlar (`mcr.microsoft.com/dotnet/sdk:10.0`), varsayılan olarak Linux üzerinde çalışacak şekilde iniyor.
- `Grpc.Tools` NuGet paketinin içinden çıkan, Microsoft'un önceden derleyip pakete koyduğu `protoc` (Linux sürümü) dosyası, henüz .NET 10 preview container'larında ARM64 çekirdeğine tam uyum sağlayamamış bir bellek bug'ına sahip. Bu dosya çalışmaya başladığı anda çökmektedir.

#### 2. Sorunu Nasıl Çözdük? (ARM64 / Mac Apple Silicon Konfigürasyonu)
Sorunu çözmek (bypass etmek) için harika bir yöntem uyguladık: Microsoft'un NuGet paketinin içinden gelen o bozuk "hazır" derleyiciyi kullanmayı reddettik. Bunun yerine, konteynerın işletim sistemi olan Debian Linux'un kendi yasal depolarındaki (apt-get) orijinal ve saf `protobuf-compiler` programını kurduk ve MSBuild sistemine (.NET derleyicisine) *"Sen paket içindekini boşver, işlemleri benim yeni kurduğum sistem aracına yaptır"* dedik.

Dockerfile kodlarımızda ARM64 (Mac) için uyguladığımız değişiklik şöyledir:

```dockerfile
# 1. İşletim sisteminin orijinal, CPU ile %100 uyumlu derleyicisini indir ve kur (apt-get)
RUN apt-get update && apt-get install -y protobuf-compiler

# 2. .NET Publish komutuna, Grpc paketinin içindekini değil (/usr/bin/protoc) yolundaki yeni programı kullanmasını zorunlu kıl
RUN dotnet publish -c Release -o /app/publish -p:Protobuf_ProtocFullPath=/usr/bin/protoc
```

#### 3. AMD64 (Intel/AMD) Bir Bilgisayarda Olsaydık Ne Olacaktı?
Eğer bu projeyi bir **Intel/AMD** işlemcili Windows ya da Mac bilgisayarda çalıştırsaydık (Yani **x86_64 / amd64** mimarisi), yukarıdaki hatanın **hiçbiriyle karşılaşmayacaktık**. Çünkü `Grpc.Tools` paketinin içerisindeki varsayılan Linux/amd64 aracı yıllardır stabil ve sorunsuz çalışmaktadır.

Bu durumda, o 5 projemizin `Dockerfile` kodları son derece sade kalacaktı ve o ekstra iki satır Linux komutuna hiç ihtiyacımız olmayacaktı. AMD64 için Dockerfile yapısı (Orijinal Hali) şöyle olurdu:

```dockerfile
# Intel AMD64 Standart Konfigürasyonu (Sorunsuz)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
WORKDIR /src/src/Identity.API
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Identity.API.dll"]
```

*Not: Şirketinizdeki CI/CD (GitHub Actions) sunucuları %99 oranında standart Linux Ubuntu (AMD64) makinelerdir. Dolayısıyla CI/CD sürecini yazarken bu `apt-get` trick'ine ihtiyacımız olmayabilir, ancak yazdığımız bu çözüm geriye dönük (AMD64) ile de tamamen uyumlu olduğu için hiçbir sunucuyu bozmayacaktır. Hem Apple bilgisayarı olan geliştiricileri kurtarmış olduk, hem de CI platformlarında sorunsuzca çalışmasını garanti altına aldık.*
