# Adım 17: MetalLB ve Networking Altyapısı Başarıyla Kuruldu

Bu aşamada cluster'ımızın dış dünya ile konuşmasını sağlayacak olan LoadBalancer katmanı (MetalLB) başarıyla yapılandırılmıştır.

## Yapılan İşlemler
1. **Ansible & Helm Entegrasyonu:** `networking.yml` playbook'u ile Master node üzerine otomatik olarak `helm` kuruldu ve MetalLB repository'si eklendi.
2. **MetalLB Kurulumu:** MetalLB controller ve speaker servisleri cluster üzerinde ayağa kaldırıldı.
3. **L2 Yapılandırması:** Cluster'ın `192.168.2.100 - 192.168.2.110` aralığındaki IP'leri LoadBalancer olarak kullanabilmesi sağlandı.
4. **Doğrulama Testi:** Bir `nginx` servisi LoadBalancer tipinde açılarak `192.168.2.101` IP'sini başarıyla aldığı teyit edildi.

## Cluster Networking Durumu

| Bileşen | Durum | Versiyon |
| :--- | :--- | :--- |
| **MetalLB Controller** | Running | 0.14.9 |
| **MetalLB Speaker** | Running (on all nodes) | 0.14.9 |
| **IP Pool Range** | 192.168.2.100 - 110 | - |

## Sonraki Adımlar
1. **Gateway API & Traefik Yapılandırması:** Modern trafik yönlendirme kurallarının belirlenmesi.
2. **Internal Registry:** Docker imajlarımızı saklayacağımız yerel registry kurulumu.
3. **DevOps Araçları:** Jenkins ve Gitea kurulumlarının başlatılması.

**Devam edeyim mi?**

ONAY BEKLENİYOR
