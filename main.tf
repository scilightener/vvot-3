terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone                     = "ru-central1-a"
  service_account_key_file = pathexpand("~/.yc-keys/key.json")

  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

# network
resource "yandex_vpc_network" "network" {
  name = "vvot32-nextcloud-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name              = "vvot32-nextcloud-subnet" 
  zone              = "ru-central1-a"
  v4_cidr_blocks    = ["192.168.10.0/24"]
  network_id        = yandex_vpc_network.network.id
}

# os
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts-oslogin"
}

# resources
resource "yandex_compute_disk" "boot-disk" {
  name = "vvot32-nextcloud-boot-disk"
  type = "network-ssd"
  image_id = data.yandex_compute_image.ubuntu.id
  size = 10
}

# vm
resource "yandex_compute_instance" "nextcloud-vm" {
  name = "vvot32-nextcloud-vm"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# outputs
output "vm_external_ip" {
  value = yandex_compute_instance.nextcloud-vm.network_interface.0.nat_ip_address
}

resource "local_file" "template" {
  filename = "inventory.ini"
  content  = replace(file("inventory.ini.template"), "{IP}", yandex_compute_instance.nextcloud-vm.network_interface[0].nat_ip_address)
}
