# Hands-on 25: Git Yanlış Push ve Branch Kurtarma Rehberi

Bu rehber, yanlışlıkla hatalı bir branch'e (örneğin `main`) kod pushlandığında veya tag (etiket) atıldığında bu durumun nasıl geri alınacağını ve düzeltileceğini anlatır.

## 🆘 Durum 1: Kod Yanlış Branch'e Gitti (Sadece Tag Değil)
Eğer `dev` yerine `main`'e push yaptıysanız:

1. **Uzak Branch'i Geri Çekme (Force Push):**
   `main` branch'ini eski kararlı commit'e döndürün:
   ```bash
   # DİKKAT: Bu işlem risklidir, dikkatli olun!
   git push origin +<eski-commit-id>:main
   ```

2. **Değişiklikleri Doğru Branch'e Gönderme:**
   ```bash
   git checkout dev
   git push origin dev
   ```

## 🏷️ Durum 2: Etiket (Tag) Yanlış Branch'e/Commit'e Gitti
`argocd-ready-v1` gibi bir etiketi yanlış yere bastıysanız:

1. **Yerelde Etiketi Sil:**
   ```bash
   git tag -d argocd-ready-v1
   ```

2. **Uzak Sunucuda Etiketi Sil:**
   ```bash
   git push origin -d argocd-ready-v1
   ```

3. **Doğru Commit'te Yeniden Etiketle:**
   ```bash
   git tag -a argocd-ready-v1 -m "Doğru mesaj"
   git push origin --tags
   ```

## 🛡️ Best Practices (En İyi Uygulamalar)
- **Komut Yazarken Dikkat:** `git push origin dev` komutunu alışkanlık haline getirin.
- **Her Zaman Kontrol:** Push yapmadan önce `git status` ve `git branch` çalıştırın.
- **Alias Kullanımı:** Sık yapılan hataları önlemek için `.gitconfig` içerisinde kısa ve güvenli aliaslar tanımlayın.

---
Hata yapmak geliştirme sürecinin doğal bir parçasıdır. Önemli olan bu hataları yönetebilmektir.
