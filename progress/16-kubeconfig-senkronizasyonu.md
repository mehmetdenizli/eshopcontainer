# Adım 16: Kubeconfig Senkronizasyonu ve Lokal Erişim

Bu adımda, K3s cluster'ını Master node'a bağlanmadan, doğrudan ana makineden (Mac) yönetebilmek için gerekli `kubeconfig` yapılandırması gerçekleştirilmiştir.

## Yapılan İşlemler
1. **Ansible Fetch:** Master üzerindeki `/etc/rancher/k3s/k3s.yaml` dosyası Ansible aracılığıyla güvenli bir şekilde lokal makineye çekildi.
2. **Dinamik IP Güncellemesi:** Dosya içerisindeki `127.0.0.1` (loopback) adresi, master node'un gerçek IP adresi (`192.168.2.85`) ile otomatik olarak değiştirildi.
3. **Dosya Konumu:** Güncel konfigürasyon dosyası `/ansible/kubeconfig` dizinine yerleştirildi.
4. **Dinamik Yapılandırma:** İşlem sırasında master node IP'si Ansible değişkenlerinden (`{{ ansible_host }}`) dinamik olarak çekildi. Statik bir IP girilmediği için sunucu IP'si değişse bile otomasyon çalışmaya devam edecektir.
5. **Bağlantı Testi:** Lokal terminal üzerinden `kubectl` komutu ile cluster'a erişim sağlandığı ve tüm düğümlerin (nodes) sağlıklı olduğu doğrulandı.

## Lokal Erişim Doğrulaması
```bash
export KUBECONFIG=./ansible/kubeconfig
kubectl get nodes
```

| Node Name | Status | Roles | Version |
| :--- | :--- | :--- | :--- |
| **k3s-master** | Ready | control-plane | v1.34.5+k3s1 |
| **k8s-worker** | Ready | <none> | v1.34.5+k3s1 |

## Sonraki Adımlar
1. Kubernetes Gateway API yapılandırması.
2. MetalLB veya benzeri bir LoadBalancer simülasyonu.
3. DevOps araçlarının (Jenkins, Gitea) cluster üzerine kurulumu.

**Devam edeyim mi?**

ONAY BEKLENİYOR
