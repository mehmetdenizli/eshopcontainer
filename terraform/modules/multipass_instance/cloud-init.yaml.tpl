#cloud-config
hostname: ${hostname}
manage_etc_hosts: true
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_public_key}

package_update: true
package_upgrade: true
packages:
  - curl
  - git
  - jq
  - unzip
  - apt-transport-https
  - ca-certificates
  - gnupg
  - lsb-release

runcmd:
  - timedatectl set-timezone Europe/Istanbul
  - echo "Instance ${hostname} is ready." >> /var/log/provision.log
