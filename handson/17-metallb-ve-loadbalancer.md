# Hands-on 17: MetalLB ve LoadBalancer Yönetimi

Bu rehber, lokal Kubernetes cluster'ınızda dış IP (External IP) alabilmenizi sağlayan MetalLB'nin nasıl çalıştığını ve nasıl test edileceğini açıklar.

## 1. Kurulumu Doğrulama
MetalLB bileşenlerinin durumunu kontrol edin:
```bash
kubectl --kubeconfig ./ansible/kubeconfig get pods -n metallb-system
```
*Not: `controller` ve her node için bir adet `speaker` pod'unun "Running" olması gerekir.*

## 2. IP Havuzu Kontrolü
Atanan IP aralığını görmek için:
```bash
kubectl --kubeconfig ./ansible/kubeconfig get ipaddresspools -n metallb-system
```

## 3. İlk LoadBalancer Servisinizi Oluşturun
Bir test servisi açarak MetalLB'nin IP atayıp atamadığını görelim:

1. Basit bir Nginx deployment oluşturun:
   ```bash
   kubectl --kubeconfig ./ansible/kubeconfig create deploy networking-test --image=nginx
   ```
2. Bu deployment'ı LoadBalancer olarak dışarı açın:
   ```bash
   kubectl --kubeconfig ./ansible/kubeconfig expose deploy networking-test --port=80 --type=LoadBalancer
   ```
3. Atanan IP'yi kontrol edin:
   ```bash
   kubectl --kubeconfig ./ansible/kubeconfig get svc networking-test
   ```

**Beklenen Çıktı:**
`EXTERNAL-IP` sütununda `192.168.2.100` ile `110` arasında bir IP görmelisiniz. Bu IP'ye tarayıcınızdan gittiğinizde "Welcome to nginx!" sayfasını görmeniz gerekir.

## 4. Temizlik
Test servislerini silmek için:
```bash
kubectl --kubeconfig ./ansible/kubeconfig delete svc networking-test
kubectl --kubeconfig ./ansible/kubeconfig delete deploy networking-test
```

## 5. Gateway API Notu
K3s v1.26+ ile gelen Gateway API desteği sayesinde, Ingress yerine `Gateway` ve `HTTPRoute` objelerini kullanabilirsiniz. MetalLB, oluşturduğunuz `Gateway` objesine de otomatik olarak bu havuzdan bir IP atayacaktır.

---
Artık cluster içindeki herhangi bir servisi dış dünyaya (ana makinenize) "gerçek bir IP" ile açma gücüne sahipsiniz.
