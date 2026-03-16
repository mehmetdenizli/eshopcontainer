# Hands-on 26: Helm Chart Mimarisi ve Paket Yönetimi

Kubernetes üzerindeki karmaşık mikroservis uygulamalarını yönetmek için "Kubernetes Paket Yöneticisi" olan **Helm**'i kullanıyoruz. Bu döküman, Helm'in neden seçildiğini, yapısını ve bu projede uygulayacağımız özel şablon stratejisini açıklar.

## ❓ Neden Helm Kullanıyoruz?

Kubernetes manifestoları (Deployment, Service, Ingress vb.) düz statik YAML dosyalarıdır. eShopOnContainers gibi çok servisli projelerde şu sorunları Helm ile çözüyoruz:

1. **Şablonlama (Templating):** Aynı YAML yapısını farklı imaj adları veya konfigürasyonlarla onlarca servis için tekrar yazmak yerine, bir kez yazıp değişkenlerle (`values.yaml`) özelleştiriyoruz.
2. **Sürüm Kontrolü (Rollback):** Bir deployment hatalı giderse `helm rollback` ile saniyeler içinde eski sürüme dönebiliriz.
3. **Yaşam Döngüsü Yönetimi:** Uygulamayı bir bütün olarak kurup, güncelleyip veya tek komutla kaldırabiliriz.

## 🏗️ Helm Chart Yapısı

Standart bir Helm Chart şu dosya hiyerarşisine sahiptir:

```text
my-service/
├── Chart.yaml          # Chart hakkında meta bilgiler (isim, versiyon)
├── values.yaml         # Default değişken değerleri
├── charts/             # (Opsiyonel) Bağımlı olunan alt chartlar
└── templates/          # Kubernetes manifest şablonları
    ├── deployment.yaml
    ├── service.yaml
    └── _helpers.tpl    # Tekrar eden kod blokları (Snippets)
```

## 🛠️ eShopOnContainers İçin Template Stratejimiz

Projemizde **"Base-Child Chart"** (veya Lib Chart) yaklaşımını kullanacağız. 15+ mikroservisin her biri için ayrı ayrı `deployment.yaml` yazmak yerine:

1. **Common Library:** Ortak bir kütüphane oluşturacağız.
2. **Generic Deployment:** Mikroservislerin %90'ı aynı standartlarda (Stateless, REST API) olduğu için tek bir ana şablon kullanacağız.
3. **Values Overriding:** Her servis sadece kendine has bilgileri (İmaj adı, port, env variables) kendi `values.yaml` dosyasında belirtecek.

### Örnek İşleyiş:
`deployment.yaml` içinde sabit port yazmak yerine:
```yaml
containerPort: {{ .Values.service.port }}
```
Yazıyoruz ve `values.yaml` içinde her servis için bunu değiştiriyoruz:
```yaml
# Catalog Service Values
service:
  port: 80
```

## 🔄 İş akışı (Workflow)

1. **Geliştirme:** Helm şablonları hazırlanır.
2. **Paketleme:** `helm package` ile uygulama paketlenir (veya doğrudan Git'te tutulur).
3. **Dağıtım:** ArgoCD bu Helm Chart'ı okur, değişkenleri (`values.yaml`) inject eder ve Kubernetes'e basar.

## ⚠️ Karşılaşılan Hatalar ve Çözümleri
> **Not:** Bu bölüm teknik adımlar başladığında yaşanacak hatalarla güncellenecektir.

---
Helm sayesinde altyapımız "kodlanabilir" ve "tekrar kullanılabilir" bir hale geliyor. Bir sonraki adımda ilk Base Chart'ımızı oluşturacağız.
