# Hands-on 01: Host Makine Hazırlığı ve Host Dosyası Senkronizasyonu

Bu rehber, eShopOnContainers altyapısının sorunsuz çalışması için ana makinenizde (Mac) yapmanız gereken manuel hazırlıkları içerir.

## 1. Multipass Kurulumu
Eğer sisteminizde yüklü değilse, Multipass'ı şu komutla kurabilirsiniz:
```bash
brew install --cask multipass
```

## 2. /etc/hosts Güncellemesi (Manuel)
Altyapımızdaki sunuculara isimleri üzerinden (hostname) erişebilmek için Terraform kurulumu bittikten sonra size vereceğim gerçek IP adreslerini `/etc/hosts` dosyanıza eklemeniz gerekecektir.

**Süreç Şöyle İşleyecek:**
1. Terraform sunucuları oluşturacak.
2. Gerçek IP adresleri belirlenecek.
3. Ben size kopyalamaya hazır bir liste sunacağım (örneğin: `hosts_to_paste.txt`).
4. Siz bu listeyi `/etc/hosts` dosyanıza yapıştıracaksınız.

### Nasıl Güncellenir?
1. Terminali açın.
2. `sudo nano /etc/hosts` komutunu çalıştırın.
3. Yukarıdaki blokları dosyanın en altına yapıştırın.
4. `CTRL+O` ve `ENTER` ile kaydedin, `CTRL+X` ile çıkın.
5. (Opsiyonel - İstenirse) Dosyayı korumaya almak için: `sudo chattr +i /etc/hosts` (Dikkat: Bu işlemden sonra dosyayı güncellemek isterseniz önce `sudo chattr -i /etc/hosts` yapmanız gerekir).

## 3. SSH Anahtar Hazırlığı
Terraform sunuculara erişmek için sizin public key'inizi kullanacak. Eğer anahtarınız yoksa:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_eshop
```

Bu anahtar yolu daha sonra Terraform değişkenlerinde kullanılacaktır.
