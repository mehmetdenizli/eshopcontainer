# Hands-on 02: İlk Sunucunun (k3s-master) Terraform ile Provision Edilmesi

Bu rehber, Terraform kullanarak ilk Multipass sunucumuzu nasıl ayağa kaldıracağınızı adım adım açıklar.

## 1. Hazırlık
Öncelikle Slack/SSH anahtarınızın (`~/.ssh/id_rsa.pub`) olduğundan emin olun. Eğer farklı bir anahtar kullanıyorsanız `terraform/main.tf` içindeki yolu güncelleyin.

## 2. Terraform Başlatma (Init)
`terraform/` dizinine gidin ve gerekli sağlayıcıyı (provider) indirin:
```bash
cd terraform
terraform init
```

## 3. Planlama
Herhangi bir işlem yapmadan önce neyin değişeceğini görün:
```bash
terraform plan
```

## 4. Uygulama (Apply)
Sunucuyu oluşturun. Bu işlem birkaç dakika sürebilir (Ubuntu imajının indirilmesi ve paket kurulumları dahil):
```bash
terraform apply -auto-approve
```

## 5. IP Adresini Alıp Host Dosyasına Ekleme
Komut bittiğinde ekranın en altında bir blok göreceksiniz. Şuna benzer:
```text
hosts_entries = <<EOT
# --- eShopOnContainers DevOps Altyapısı (Dinamik) ---
192.168.64.2  k3s-master
# --------------------------------------------------
EOT
```
Bu bloğu kopyalayıp ana makinenizdeki `/etc/hosts` dosyasına yapıştırın.

## 6. SSH ile Bağlantı Testi
```bash
ssh ubuntu@k3s-master
```

Bağlanabiliyorsanız ilk sunucunuz başarıyla kurulmuş demektir!
