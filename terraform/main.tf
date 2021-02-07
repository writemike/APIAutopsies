provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

// A single Compute Engine instance used for the NGINX Controller Install
resource "google_compute_instance" "nginx-controller" {
  name         = "${var.prefix}-nginx-controller"
  machine_type = var.nginx_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.nginx_controller_os_image
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
      host        = google_compute_instance.nginx-controller.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    working_dir = "../ansible/"
    command     = "ansible-playbook -i ${google_compute_instance.nginx-controller.network_interface.0.access_config.0.nat_ip}, --private-key ${var.ssh_pri_key_path} -e \"ctr_ip=${google_compute_instance.nginx-controller.network_interface.0.network_ip}\" install_controller.yaml"
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

}
#This VARS file is created to be used by Ansible to add new NGINX Plus Instances to NGINX Controller
resource "local_file" "ctr_var_file" {
  content = templatefile("${path.module}/ctr-ip.tmpl", {
    nginx_controller_ip                  = google_compute_instance.nginx-controller.network_interface.0.network_ip
    nginx_controller_nat_ip              = google_compute_instance.nginx-controller.network_interface.0.access_config.0.nat_ip
    }
  )
  filename = "../ansible/ctr_var_file.yaml"
}