# Hands-on 20: Jenkins Kullanımı ve İlk Yapılandırma

Jenkins sunucunuz (`192.168.2.89:8080`) aktif ve tüm kritik eklentilerle birlikte hazırlandı. İşte bilmeniz gerekenler:

## 1. Giriş ve Güvenlik
Tarayıcınızdan Jenkins'e erişin:
- **URL:** [http://192.168.2.89:8080](http://192.168.2.89:8080)
- **Kullanıcı:** `admin`
- **Şifre:** `P@ssword123!`

> [!CAUTION]
> Giriş yaptıktan sonra sağ üstteki profilinizden **"Configure"** (Yapılandır) kısmına giderek şifrenizi mutlaka değiştirin.

## 2. Docker Yetenek Testi
Jenkins'in Docker komutlarını çalıştırabildiğini doğrulamak için:
1. "New Item" -> "Pipeline" oluşturun (İsim: `test-docker`).
2. Pipeline script alanına şunu yapıştırın:
   ```groovy
   pipeline {
       agent any
       stages {
           stage('Check Docker') {
               steps {
                   sh 'docker version'
               }
           }
       }
   }
   ```
3. Build butonuna basın. Loglarda Docker versiyonunu görüyorsanız "Docker-in-Docker" yapısı çalışıyor demektir.

## 3. Depolama Yönetimi (Disk Tasarrufu)
Sunucunun dolmasını önlemek için şu özellikler aktiftir:
- **Build Discarder:** Projelerinizde "Strategy: Log Rotation" seçerek sadece son X build'i saklayabilirsiniz.
- **Otomatik Temizlik:** Her gece 03:00'te sunucu kendi Docker çöplerini temizler.
- **Pipeline Temizliği:** Pipeline script'lerinizin sonuna mutlaka `cleanWs()` ekleyin:
  ```groovy
  post {
      always {
          cleanWs()
      }
  }
  ```

## 4. Gitea Entegrasyonu
Jenkins ve Gitea'nın birbiriyle konuşması için:
1. Jenkins -> **Manage Jenkins** -> **System** yolundan Gitea sunucusu olarak `http://192.168.2.90:3000` adresini ekleyin.
2. Gitea'dan bir "Personal Access Token" alıp Jenkins'e "Credentials" olarak tanımlayın.

---
Artık projelerimizi otomatize etmeye başlayabiliriz!
