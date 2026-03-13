# Adım 15: K3s Cluster Kurulumu Başarıyla Tamamlandı

Bu aşamada Ansible kullanarak K3s Kubernetes cluster'ımızı (Master + Worker) otomatik olarak kurduk.

## Cluster Durumu
Bütün düğümler (nodes) başarılı bir şekilde birbirine bağlandı ve çalışır durumda:

| Node Name | Status | Roles | Version |
| :--- | :--- | :--- | :--- |
| **k3s-master** | Ready | control-plane | v1.34.5+k3s1 |
| **k8s-worker** | Ready | <none> | v1.34.5+k3s1 |

## Yapılan İşlemler
1. **Ansible Hazırlığı:** Ana makineye (Mac) Ansible kuruldu (`brew install ansible`).
2. **Envanter Doğrulama:** 7 sunucuya (`all`) ping atılarak erişim test edildi.
3. **Master Kurulumu:** `k3s-master` sunucusunda K3s control plane başlatıldı ve cluster token'ı otomatik alındı.
4. **Worker Kurulumu:** `k8s-worker` düğümü, master'dan alınan güvenli token ile cluster'a dahil edildi.
5. **Doğrulama:** `kubectl get nodes` komutu ile cluster bütünlüğü onaylandı.

## Sonraki Adımlar
1. Kubeconfig dosyasının ana makineye (Mac) aktarılması.
2. Kubernetes Dashboard veya Lens ile görsel kontrol sağlanması.
3. Diğer altyapı bileşenlerinin (Jenkins, Monitoring vb.) kurulumu.

**Devam edeyim mi?**

ONAY BEKLENİYOR
