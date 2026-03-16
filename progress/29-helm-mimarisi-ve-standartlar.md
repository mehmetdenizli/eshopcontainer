# Adım 29: Helm Mimarisi ve Template Standardizasyonu

Bu aşamada, mikroservislerin Kubernetes üzerine sürdürülebilir ve yönetilebilir bir şekilde dağıtılması için Helm mimarisi tasarlanmıştır.

## 🎯 Amaç
Statik YAML dosyalarının yönetilemezliğini (YAML Hell) ortadan kaldırmak ve mikroservis dağıtım süreçlerini otomatize etmek.

## 🏗️ Mimari Kararlar
1. **Modüler Yapı:** Tüm mikroservisler için ortak bir "Common Template" yapısı benimsendi.
2. **Values-Driven Deployment:** Dağıtım parametrelerinin (resource limits, portlar, env vars) `values.yaml` üzerinden merkezi yönetimi sağlandı.
3. **ArgoCD Entegrasyonu:** Helm Chartların ArgoCD tarafından dinamik olarak render edilip cluster'a uygulanması hedeflendi.

## 📍 Planlanan Yapı
- **Base Chart:** Standart bir mikroservis için gereken tüm K8s bileşenlerini içeren ana şablon.
- **Microservices Charts:** Her servis için Base Chart'ı referans alan veya minimal values dosyası içeren yapılar.

## ⏭️ Bir Sonraki Adım
- Gitea üzerinde `eshop-deployment` reposunun oluşturulması.
- Base Helm Chart'ın kodlanması.
