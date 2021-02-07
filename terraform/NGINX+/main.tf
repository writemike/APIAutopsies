provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

// A single Compute Engine instance
resource "google_compute_instance" "nginx-plus" {
  count        = 3
  name         = "${var.prefix}-nginx-plus-${count.index + 1}"
  machine_type = var.plus_machine_type
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = var.nginx_plus_os_image
      size  = 100
    }
  }

  metadata_startup_script = "sudo apt-get update -y;"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.ssh_pri_key_path)
      host        = self.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    working_dir = "../../ansible/"
    command     = "ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key ${var.ssh_pri_key_path} install_plus.yaml"
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = "../../ansible/"
    #command     = "ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key ${var.ssh_pri_key_path} -e \"nginx_plus_count=${count.index + 1}\" remove_plus.yaml"
    command     = "ansible-playbook -i ${self.network_interface.0.access_config.0.nat_ip}, --private-key \"/home/APIAutopsies/terraform/ssh/id_rsa\" -e \"nginx_plus_count=${count.index + 1}\" remove_plus.yaml"
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

}

