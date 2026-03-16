# Adım 22: Hashicorp Vault (Secret Management) Kurulumu

Bu aşamada, projenin tüm hassas verilerini (veritabanı şifreleri, API anahtarları, sertifikalar) güvenli bir şekilde saklayacak olan **Hashicorp Vault** kurulumu gerçekleştirilmiştir.

## Teknik Bileşenler
1. **Sunucu:** `vault-srv` (192.168.2.92) üzerinde Docker Compose ile yapılandırıldı.
2. **Depolama (Backend):** "File" backend kullanılarak verilerin `/home/ubuntu/vault/data` dizininde kalıcı olması sağlandı.
3. **Arayüz:** Vault UI aktif edildi (Port 8200).
4. **Güvenlik Politikas:** Lokal lab ortamı olduğu için TLS (HTTPS) devre dışı bırakıldı (tls_disable = 1), ancak production ortamları için TLS zorunludur.

## Güvenlik Notu: Unseal İşlemi
Vault, kurulduğunda "Sealed" (Mühürlü) durumdadır. Verilere erişebilmek için:
- Sistemin ilk kez **Initialize** edilmesi gerekir.
- Oluşan **Unseal Keys** (veya Shamir Keys) güvenli bir yerde saklanmalıdır.
- Her sunucu yeniden başladığında en az 3 anahtar ile Vault "unseal" edilmelidir.

## Erişim Bilgileri
- **Vault URL:** `http://192.168.2.92:8200`
- **Durum:** Aktif ancak Uninitialized (Mühürlü).

---
**ANTIGRAVITY NOTU:** "Kasa" (Vault) hazır ancak henüz kilitli. Bir sonraki adımda bu kasayı birlikte açacağız.
