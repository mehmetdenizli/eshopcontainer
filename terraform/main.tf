terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.0"
    }
  }
}

provider "multipass" {}

module "k3s_master" {
  source         = "./modules/multipass_instance"
  vm_name        = "k3s-master"
  cpu            = 1
  ram            = "2G"
  disk           = "10G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "k8s_worker" {
  source         = "./modules/multipass_instance"
  vm_name        = "k8s-worker"
  cpu            = 2
  ram            = "4G"
  disk           = "25G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "jenkins" {
  source         = "./modules/multipass_instance"
  vm_name        = "jenkins-srv"
  cpu            = 1
  ram            = "3G"
  disk           = "15G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "monitoring" {
  source         = "./modules/multipass_instance"
  vm_name        = "monitoring-srv"
  cpu            = 1
  ram            = "2G"
  disk           = "15G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "security" {
  source         = "./modules/multipass_instance"
  vm_name        = "security-srv"
  cpu            = 1
  ram            = "3G"
  disk           = "10G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "git" {
  source         = "./modules/multipass_instance"
  vm_name        = "git-srv"
  cpu            = 1
  ram            = "1.5G"
  disk           = "15G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

module "vault" {
  source         = "./modules/multipass_instance"
  vm_name        = "vault-srv"
  cpu            = 1
  ram            = "512M"
  disk           = "5G"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

output "hosts_entries" {
  value = <<-EOT
    # --- eShopOnContainers DevOps Altyapısı (Dinamik) ---
    ${module.k3s_master.instance_ip}  k3s-master
    ${module.k8s_worker.instance_ip}  k8s-worker
    ${module.jenkins.instance_ip}  jenkins.local
    ${module.monitoring.instance_ip}  monitoring-srv
    ${module.security.instance_ip}  security.local
    ${module.git.instance_ip}  git.local
    ${module.vault.instance_ip}  vault.local
    # --------------------------------------------------
  EOT
}
