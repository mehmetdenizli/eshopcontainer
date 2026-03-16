terraform {
  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.0"
    }
  }
}

resource "local_file" "cloudinit" {
  content = templatefile("${path.module}/cloud-init.yaml.tpl", {
    hostname       = var.vm_name
    ssh_public_key = var.ssh_public_key
  })
  filename = "${path.module}/rendered_cloudinit_${var.vm_name}.yaml"
}

resource "multipass_instance" "this" {
  name           = var.vm_name
  cpus           = var.cpu
  memory         = var.ram
  disk           = var.disk
  cloudinit_file = local_file.cloudinit.filename
}

output "instance_ip" {
  value = multipass_instance.this.ipv4
}

output "instance_name" {
  value = multipass_instance.this.name
}
