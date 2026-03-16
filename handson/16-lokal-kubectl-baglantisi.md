# Hands-on 16: Lokal Makineden Kubernetes Erişimi

Bu rehber, K3s cluster'ını kendi bilgisayarınızdaki (Mac) terminalden nasıl yöneteceğinizi adım adım açıklar.

## 1. Kubeconfig Hazırlığı
Ansible playbook'umuz `kubeconfig` dosyasını otomatik olarak oluşturdu ve IP adresini güncelledi. Dosyanın yerini kontrol edin:
```bash
ls -l ansible/kubeconfig
```

## 2. Ortam Değişkenini Ayarlama
`kubectl` komutunun bu dosyayı kullanması için terminal oturumunuzda `KUBECONFIG` değişkenini ihraç (export) etmeniz gerekir:

```bash
export KUBECONFIG=$(pwd)/ansible/kubeconfig
```

*İpucu: Bunu kalıcı hale getirmek için `.zshrc` dosyanıza ekleyebilirsiniz.*

## 3. Bağlantı Testi
Düğümlerin listesini alarak bağlantıyı test edin:

```bash
kubectl get nodes
```

**Beklenen Çıktı:**
```text
NAME         STATUS   ROLES           AGE   VERSION
k3s-master   Ready    control-plane   20m   v1.34.5+k3s1
k8s-worker   Ready    <none>          15m   v1.34.5+k3s1
```

## 4. Problem Giderme (Troubleshooting)

### "Unable to connect to the server" hatası alıyorsanız:
1. Master node'un ayakta olduğundan emin olun: `multipass list`
2. IP adresinin doğru olduğunu kontrol edin: `grep server ansible/kubeconfig`
3. Güvenlik duvarı (firewall) veya VPN bağlantılarınızın master IP'sine (`192.168.2.85`) erişimi engellemediğinden emin olun.

### "Permission Denied" hatası alıyorsanız:
Mac üzerindeki `ansible/kubeconfig` dosyasının okuma izinlerini kontrol edin:
```bash
chmod 600 ansible/kubeconfig
```

---
Bu aşamadan sonra tüm işlemlerimizi Mac terminalinden `kubectl` kullanarak yapabiliriz.

## 5. İleri Düzey Kullanım İpuçları

### Her Komutta Dosya Yolunu Belirtmek
Eğer `export` kullanmak istemiyorsanız, doğrudan dosya yolunu parametre olarak verebilirsiniz:
```bash
kubectl --kubeconfig ./ansible/kubeconfig get nodes
```

### Kalıcı Erişim (Alias)
Her seferinde uzun komut yazmamak için `.zshrc` dosyanıza şu alias'ı ekleyebilirsiniz:
```bash
alias k="kubectl --kubeconfig $(pwd)/ansible/kubeconfig"
```

## 6. Dinamik Yapılandırma Hakkında
**Önemli:** Playbook içerisindeki IP güncelleme işlemi tamamen **dinamiktir**.
- Ansible, envanter dosyasındaki (`hosts.ini`) `ansible_host` değerini (`{{ ansible_host }}`) otomatik olarak alır.
- Master node IP'si değişse bile, playbook'u tekrar çalıştırdığınızda `kubeconfig` dosyasındaki adres otomatik olarak yeni IP ile güncellenir. Statik bir IP manuel olarak girilmemiştir.
