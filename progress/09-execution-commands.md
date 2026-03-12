# Çalıştırma ve Temizlik Komutları

Bu doküman, projeyi hem .NET Aspire hem de Docker Compose ile nasıl başlatacağınızı ve sonrasında sistemi tamamen nasıl temizleyeceğinizi açıklar.

## 1. Docker Compose Yöntemi

Geleneksel Docker orkestrasyonu ile tüm sistemi ayağa kaldırmak için kullanılır.

### Başlatma
```bash
docker-compose up --build -d
```

### Durdurma ve Temizleme
```bash
docker-compose down
```
*Not: Bu komut konteynerları durdurur ve siler, ancak oluşturulan volume'ları (veritabanı verilerini) korur. Verileri de silmek isterseniz `docker-compose down -v` kullanabilirsiniz.*

---

## 2. .NET Aspire Yöntemi

Geliştirici dostu, Dashboard destekli orkestrasyon.

### Başlatma
```bash
dotnet run --project src/eShop.AppHost/eShop.AppHost.csproj
```

### Durdurma
Terminalde `Ctrl + C` tuşlarına basarak ana süreci durdurabilirsiniz.

### Tam Temizlik (Persistent Containerlar Dahil)
Aspire, veritabanı verilerini korumak için bazı konteynerları (`postgres`, `eventbus`) durdurduktan sonra bile ayakta bırakabilir. Her şeyi tamamen temizlemek için şu komutu kullanabilirsiniz:

```bash
docker ps -q | xargs -r docker stop && docker ps -a -q | xargs -r docker rm -f
```

*(Bu komut o an çalışan TÜM Docker konteynerlarını durdurur ve siler. Sadece eShop ile ilgili olanları silmek isterseniz Docker Desktop arayüzünü de kullanabilirsiniz.)*

---

## Özet Tablo

| Senaryo | Başlatma Komutu | Durdurma/Temizlik Komutu |
| :--- | :--- | :--- |
| **Docker Compose** | `docker-compose up --build -d` | `docker-compose down` |
| **.NET Aspire** | `dotnet run --project ...` | `Ctrl+C` + (Opsiyonel) `docker rm -f ...` |
