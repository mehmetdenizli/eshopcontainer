# Adım 37: Hashicorp Vault ve Kubernetes Secret Entegrasyonu

Bu aşamada, mikroservislerin hassas verilerini (şifreler, connection stringler) güvenli bir şekilde yönetmek için Hashicorp Vault ile Kubernetes cluster'ı (K3s) arasında tam entegrasyon sağlanmıştır.

## Yapılan İşlemler
1. **Vault Initialization & Unseal:** 
    - Vault sunucusu (`vault.local`) ilklendirildi (Initialize).
    - 5 unseal anahtarı oluşturuldu ve 3 tanesi kullanılarak kilidi açıldı.
    - Root token ve anahtarlar `ansible/vault_keys.txt` dosyasına güvenli bir şekilde kaydedildi.
2. **Kubernetes Authentication:**
    - K3s içinde `vault-auth` isimli ServiceAccount ve `ClusterRoleBinding` oluşturuldu.
    - Vault üzerinde `auth/kubernetes` metodu aktif edilerek K3s API server ile bağlantısı yapıldı.
3. **Hassas Veri Yapılandırması:**
    - `secret/` yolu altında `kv-v2` motoru aktif edildi.
    - Mikroservisler için (`identity-api`, `webapp`) ilk secret'lar Vault içine (`secret/eshop/...`) yazıldı.
4. **Vault Agent Injector:**
    - Helm kullanılarak `vault-agent-injector` bileşeni Kubernetes cluster'ına kuruldu.
    - Bu sayede podlara annotation eklenerek Vault'tan otomatik veri çekilmesi mümkün hale gelmiştir.

## Kullanılan Kaynaklar
- **Vault Server:** `vault.local` (192.168.2.92)
- **Helm Chart:** `hashicorp/vault`
- **Ansible Playbook:** `ansible/playbooks/vault-setup.yml`

## Sonuç
Mikroservislerin (`identity-api`, `webapp`) hassas verileri Vault'a taşınmış ve Vault Agent Injector aracılığıyla podlara otomatik enjeksiyon başarıyla gerçekleştirilmiştir. YAML dosyalarındaki düz metin şifreler temizlenmiş, projenin Zero Trust güvenliği pekiştirilmiştir. ✅

**Durum:** Başarıyla Tamamlandı ✅
