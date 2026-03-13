# Adım 14: K3s ve Altyapı Otomasyon Stratejisi

Tüm sunucularımız (7 adet) Multipass üzerinde ayakta olduğuna göre, şimdi bu sunucuların konfigürasyonunu (K3s, Jenkins, Vault vb.) nasıl otomatize edeceğimizi belirlememiz gerekiyor.

## Best Practice Önerisi: Ansible

Modern DevOps dünyasında bu tür çoklu sunucu kurulumları için en sağlıklı ve "best practice" yöntem **Ansible** kullanmaktır.

### Neden Ansible?
1. **Idempotency (Aynı Sonuç):** Bir playbook'u 10 kere çalıştırsanız da sunucu her zaman hedeflediğimiz durumda (desired state) kalır.
2. **Merkezi Yönetim:** K3s Master'ı kurup, kurulumdan çıkan "Token"ı otomatik alıp Worker node'una tek bir akışta iletebiliriz.
3. **Genişletilebilirlik:** Sadece K3s değil, ileride Jenkins, SonarQube ve Monitoring sunucularını da aynı yapı üzerinden kurabiliriz.
4. **Ajan Gerektirmez:** Sunuculara ek bir yazılım kurmaya gerek yok, SSH üzerinden (zaten Terraform ile bağladık) çalışır.

## Uygulama Planı

### 1. Dinamik Envanter (Inventory) Hazırlığı
Terraform'dan gelen gerçek IP'leri kullanarak `ansible/inventory/hosts.ini` dosyasını oluşturacağız.

### 2. K3s Master Role
- K3s binary indirilecek.
- Master kurulacak.
- `/etc/rancher/k3s/k3s.yaml` (kubeconfig) lokal makinemize (Mac) çekilecek.
- `JOIN_TOKEN` bir değişkene atanacak.

### 3. K3s Worker Role
- Master'dan alınan token ve IP ile Worker node cluster'a dahil edilecek.

### 4. Kubernetes Gateway API & MetalLB (Simülasyon)
Cluster kurulduktan sonra Gateway API ve LoadBalancer (yerel ortam için) yapılandırması yapılacak.

## Alternatif: k3sup (Lightweight)
Sadece K3s'e odaklanmak isterseniz `k3sup` çok hızlı bir araçtır. Ancak Jenkins, Vault gibi diğer sunucuları da kuracağımız için Ansible "ekosistem bütünlüğü" sağlar.

---
**Öneri:** Ansible ile devam edelim. Böylece tüm DevOps altyapımızı tek bir `provision-all.yml` playbook'u ile yönetebiliriz.

**Devam edeyim mi?**

ONAY BEKLENİYOR
