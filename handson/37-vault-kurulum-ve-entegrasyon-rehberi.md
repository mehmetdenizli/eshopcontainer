# Hands-on: Hashicorp Vault Kurulum ve Kubernetes Entegrasyon Rehberi

Bu rehber, kilitli bir Vault sunucusunun nasıl başlatılacağını ve Kubernetes (K3s) ile nasıl konuşturulacağını adım adım açıklar.

## 1. Vault'u İlklendirme (Initialize) ve Kilidi Açma (Unseal)

Vault konteyneri içinde operasyonu başlatın:

```bash
# Vault'u ilklendir (Anahtarları JSON formatında al)
ansible vault -i inventory/hosts.ini -m shell -a "docker exec vault vault operator init -key-shares=5 -key-threshold=3 -format=json" -b

# Çıkan anahtarlardan 3 tanesiyle kilidi aç (Unseal)
docker exec vault vault operator unseal <KEY_1>
docker exec vault vault operator unseal <KEY_2>
docker exec vault vault operator unseal <KEY_3>
```

## 2. Kubernetes Auth Yapılandırması

Kubernetes tarafında Vault'un kimlik doğrulaması yapabilmesi için bir ServiceAccount oluşturun:

```bash
# ServiceAccount ve RBAC ayarları
kubectl create serviceaccount vault-auth
kubectl create clusterrolebinding vault-auth-binding --clusterrole=system:auth-delegator --serviceaccount=default:vault-auth

# Token ve CA Sertifikasını çıkarın (Kubernetes 1.24+ için manuel secret gerekebilir)
```

Vault tarafında Kubernetes konfigürasyonunu yapın:

```bash
# Kubernetes auth metodunu aktif et
vault auth enable kubernetes

# K3s API bilgilerini Vault'a yaz
vault write auth/kubernetes/config \
    token_reviewer_jwt="<SA_TOKEN>" \
    kubernetes_host="https://192.168.2.85:6443" \
    kubernetes_ca_cert="<CA_CERT>"
```

## 3. Policy ve Role Tanımları

Uygulamaların hangi şifrelere erişebileceğini belirleyen kurallar:

```bash
# Policy oluştur
vault policy write eshop-policy - <<EOF
path "secret/data/eshop/*" {
  capabilities = ["read"]
}
EOF

# Kubernetes Role oluştur
vault write auth/kubernetes/role/eshop-role \
    bound_service_account_names=default \
    bound_service_account_namespaces=default \
    policies=eshop-policy \
    ttl=24h
```

## 4. Vault Agent Injector Kurulumu (Helm)

Cluster içine injector'ı kurun:

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault \
  --set "injector.externalVaultAddr=http://192.168.2.92:8200"
```

## Karşılaşılan Hatalar ve Çözümler

| Hata | Sebep | Çözüm |
| :--- | :--- | :--- |
| **Permission Denied (K8s Login)** | ServiceAccount yetkisi eksik. | `clusterrole=system:auth-delegator` binding'ini kontrol edin. |
| **Unseal Status: 2/3** | Eşik değere ulaşılamadı. | Bir anahtar daha (`operator unseal`) girin. |
| **Bad Cert (TLS)** | K3s CA sertifikası yanlış. | `/var/lib/rancher/k3s/server/tls/server-ca.crt` dosyasını kullanın. |
