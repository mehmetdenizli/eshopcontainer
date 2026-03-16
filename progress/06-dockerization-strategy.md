# Dockerization Strategy: Aspire vs Traditional Docker

Bu belge, modern bir .NET mikroservis mimarisinde kullanılan iki popüler "konteyner orkestrasyon ve yerel geliştirme" yaklaşımı arasındaki farkları ve hedeflerimizi açıklamaktadır. Projemizde her iki teknolojiyi de kullanarak modern araçların getirdiği hızı deneyimlerken, altyapı arka planında geleneksel standartlardan taviz vermeyeceğiz.

## 1. Yeni Nesil Yaklaşım: .NET Aspire (`eShop.AppHost`)

Bu yaklaşım, odak noktasına tamamen "Developer Deneyimi" (DX) koyar.
- **Kullanımı:** `dotnet run` (AppHost projesi üzerinden).
- **Mantığı:** Geliştiricinin manuel olarak `Dockerfile` veya `docker-compose.yml` yazmasını gerektirmez. `Program.cs` içerisindeki C# kodlarına bakarak, "Bu servisin Redis'e, şunun RabbitMQ'ya ihtiyacı var" şeklinde uygulama bileşenlerini ve bağımlılık haritasını çıkartır.
- **Avantajı:** Kurulum süresi sıfırdır. Kodlara F5 attığınız anda Dashboard üzerinden tüm logları, metrikleri ve container ağını tek tıkla izlersiniz.
- **Kullanım Yeri:** Sadece **Yerel Geliştirme Ortamında** ve kod testi esnasında kullanılır. (Aspire, production ortamlarına doğrudan `Aspirate` veya `azd` komutlarıyla YAML'lar üreterek çıkış imkanı da sunar).

## 2. Geleneksel Yaklaşım: Docker & Docker Compose

Bu yaklaşım, uzun yıllardır endüstri standardı olan klasik yapıdır.
- **Kullanımı:** `docker-compose up` (kök dizindeki YAML dosyası üzerinden).
- **Mantığı:** Her mikroservisin (API'nin) içerisinde, ilgili uygulamanın Docker imajına nasıl derleneceğini adım adım anlatan bir **`Dockerfile`** bulunur. Sonrasında kök dizindeki bir `docker-compose.yml` dosyası, tüm servislerin imajlarını, portlarını, environment variable'larını (çevre değişkenlerini) sabit bir şekilde tanımlar ve hepsini ağ bağlamında ayağa kaldırır.
- **Avantajı:** Altyapının tüm kodları (Infrastructure As Code - IAC) fiziksel olarak dökümente edilmiştir. Hangi imaj tabanının kullanıldığı veya run time'ın nasıl çalıştığı adım adım görünür. CI/CD platformlarıyla ve eski tip Kubernetes pipeline'larıyla %100 uyumludur.
- **Kullanım Yeri:** Genellikle üretim (Production), UAT, QA test ortamlarında imajların mühürlenmesi ve sunucu dağıtımlarında kullanılır.

## 3. eShop Projesi Hybrid (Karma) Kararımız

Amacımız öğrenmeyi pekiştirmek ve iki dünyanın da en iyisini projede barındırmaktır.

1. **Yerelde Geliştirme (Aspire):** Kodlarımızı yazarken, `eShop.AppHost` çalıştırılarak hızla ayağa kalkılacak ve Aspire konforu (metrikler/dağıtık tracing) kullanılacaktır.
2. **Konteyner Mimarisi Üretimi (Traditional Docker):** Sistemde `Aspire` yeteneklerinden bağımsız çalışabilen ve Kubernetes'e geleneksel Deployment YAML'ları (veya Helm Chart'ları) hazırlayabilmemiz için tüm mikroservislere özel **`Dockerfile`** dosyaları kodlanacaktır. Sistemi Aspire olmadan da manuel olarak ayağa kaldırabilmek için kök dizinde **`docker-compose.yml`** altyapısı kurulacaktır.

Bu Hybrid yaklaşım sayesinde; projedeki bir Aspire bağımlılığında dahi projenin "Pure Docker" mantığıyla çalışması güvence altına alınacaktır.
