# Hands-on 21: SonarQube ve Trivy ile Güvenlik Kontrolleri

Kodunuzun kalitesini ve imajlarınızın güvenliğini nasıl test edeceğinizi öğrenelim.

## 1. SonarQube İlk Giriş
Tarayıcınızdan `http://192.168.2.91:9000` adresine gidin:
- **Kullanıcı:** `admin`
- **Şifre:** `admin`
- *İlk girişte sizden yeni bir şifre belirlemeniz istenecektir.*

### Jenkins Entegrasyon Anahtarı Oluşturma:
1. SonarQube'de profil simgenize tıklayın -> **My Account** -> **Security**.
2. Bir isim verin (Örn: `jenkins-token`) ve **Generate** butonuna basın.
3. Bu token'ı Jenkins'te `Secret Text` olarak kaydedin.

## 2. Trivy ile İmaj Tarama (Terminalden Test)
Trivy, Jenkins makinenize kuruldu. SSH ile `jenkins-srv` makinesine girip bir imajı manuel tarayabilirsiniz:

```bash
# Sadece KRİTİK açıkları göster:
trivy image --severity CRITICAL mongo:latest
```

### Pipeline İçinde Kullanım Örneği:
Jenkins Pipeline script'inize şu aşamayı ekleyebilirsiniz:
```groovy
stage('Security Scan') {
    steps {
        sh 'trivy image --exit-code 1 --severity CRITICAL 192.168.2.90:3000/eshop/catalog:v1'
    }
}
```
*Not: `--exit-code 1` parametresi, kritik bir açık bulunursa build'in başarısız olmasını sağlar.*

## 3. Neden Bunları Kurduk?
- **SonarQube:** Kodunuzdaki "bug"ları, "code smell"leri (kötü kod kokusu) ve teknik borcu ölçer.
- **Trivy:** Docker imajlarınızın içindeki kütüphanelerde (OS packages, Python/JS libs vb.) bilinen bir güvenlik açığı (CVE) olup olmadığını kontrol eder.

---
Artık tam kapsamlı bir DevOps boru hattının (pipeline) tüm güvenlik ve kalite bileşenlerine sahipsiniz.
