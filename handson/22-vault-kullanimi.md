# Hands-on 22: Hashicorp Vault'u İlk Kez Kullanmak (Initialize & Unseal)

Vault sunucunuz (`192.168.2.92:8200`) kuruldu. Şimdi bu "kasayı" ilk kez açalım.

## 🚀 1. Vault'u İlk Kez Başlatmak (Initialize)
Vault'u ilk kurduğunuzda boş ve mühürlüdür. İki yöntemden birini seçin:

### Yöntem A: Arayüzden (Web UI)
1. Tarayıcınızdan `http://192.168.2.92:8200` adresine gidin.
2. Karşınıza çıkan "Initialize Vault" ekranında şu değerleri girin:
   - **Key shares:** 5 (Toplam anahtar sayısı)
   - **Key threshold:** 3 (Mührü açmak için gereken anahtar sayısı)
3. "Initialize" butonuna basın.
4. **ÇOK ÖNEMLİ:** Karşınıza çıkan **"Unseal Keys"** ve **"Initial Root Token"** değerlerini bir metin dosyasına kopyalayıp bilgisayarınızda ÇOK GÜVENLİ bir yerde saklayın. Bu anahtarları kaybederseniz verilere GİREREMEZSİNİZ.

### Yöntem B: Terminalden (SSH ile)
```bash
# Vault sunucusuna SSH ile bağlanın:
docker exec -it vault vault operator init
```
*Bu komut size 5 anahtar ve 1 root token verecektir.*

## 🔓 2. Kasayı Açmak (Unseal)
Vault her yeniden başladığında (Restart) tekrar mühürlenir. Kasayı açmak için:

1. Arayüzden (Web UI) veya terminalden **"Unseal"** işlemini başlatın.
2. Size verilen 5 anahtardan herhangi **3 tanesini** (threshold kadar) sırasıyla girin.
3. Vault'un durumu "Sealed: false" olduğunda kasa açılmış demektir.

## 🔐 3. Giriş Yapmak
1. Kasa açıldıktan sonra **Method: Token** seçeneğini seçin.
2. Size verilen **Initial Root Token** değerini girerek giriş yapın.

## 🔑 4. İlk Sırrınızı Ekleyin (Secret)
1. Sol menüden **Secrets Engines** -> **Enable New Engine** -> **KV** (Key-Value) seçin.
2. Path olarak `eshop` girin ve Enable edin.
3. Artık mikroservislerin şifrelerini (Örn: `eshop/identity/db_password`) burada saklayabilirsiniz.

---
Artık en üst düzey güvenlik katmanımız olan "Kasa" (Vault) parmaklarınızın ucunda.
