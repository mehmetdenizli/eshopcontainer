# Adım 20: Jenkins (CI/CD) Fabrikası Kurulumu

Bu aşamada, projenin tüm CI/CD süreçlerini yönetecek olan Jenkins sunucusu (`jenkins-srv`) yapılandırılmıştır.

## Teknik Özellikler
1. **Özel İmaj:** Jenkins LTS (JDK 17) tabanlı, içinde Docker CLI ve kritik DevOps eklentileri (plugins) önceden yüklü olan özel bir Docker imajı oluşturuldu.
2. **Docker-in-Docker:** Jenkins konteyneri, host makinenin Docker soketine (`/var/run/docker.sock`) erişecek şekilde yapılandırıldı. Bu sayede Jenkins, mikroservislerin Docker imajlarını build edebilir.
3. **Kalıcı Veri:** Tüm Jenkins ayarları ve pipeline geçmişi `/home/ubuntu/jenkins/jenkins_home` dizininde saklanmaktadır.
4. **Otomatik Başlangıç:** Bir Groovy script'i (`init.groovy`) kullanılarak admin kullanıcısı otomatik oluşturulmuş ve ilk kurulum sihirbazı atlanmıştır.

## Yüklü Kritik Eklentiler (Plugins)
- **Gitea:** Kod entegrasyonu için.
- **SonarQube Scanner:** Kod kalitesi analizi için.
- **Kubernetes & CLI:** K3s cluster'ına deployment yapmak için.
- **Docker & Pipeline:** İmaj build ve push işlemleri için.
- **Timestamper & Workspace Cleanup:** Log yönetimi ve alan tasarrufu için.
- **JUnit & Coverage:** Test raporlamaları için.

## Depolama ve Temizlik Stratejisi
- **Cron Job:** Her gece saat 03:00'te çalışan bir görev ile 24 saatten eski tüm "dangling" Docker imajları ve cache'leri otomatik temizlenir.
- **Workspace:** Pipeline'lar bittiğinde workspace'in temizlenmesi için eklenti hazır haldedir.

## Erişim Bilgileri
- **URL:** `http://192.168.2.89:8080`
- **Kullanıcı:** `admin`
- **Şifre:** `P@ssword123!`

---
**ANTIGRAVITY NOTU:** Jenkins fabrikamız artık eShopOnContainers mikroservislerini build etmeye, test etmeye ve Kubernetes'e uçurmaya hazır!
