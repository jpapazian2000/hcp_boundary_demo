resource "tls_private_key" "pgsql_priv_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

data "tls_public_key" "pgsql_pub_key" {
  private_key_openssh = tls_private_key.pgsql_priv_key.private_key_openssh
}
locals {
  privkey = nonsensitive(tls_private_key.pgsql_priv_key.private_key_openssh)
  pubkey = tls_private_key.pgsql_priv_key.public_key_openssh
  }

resource "google_compute_network" "vpc_network" {
    name = "${var.pgsql_server_name}-vpc"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
    name = "${var.pgsql_server_name}-subnet"
    region = var.google_region
    network = google_compute_network.vpc_network.self_link
    ip_cidr_range = var.google_subnet_prefix
}

resource "google_compute_firewall" "ssh_access" {
  name = "${var.pgsql_server_name}-allow-ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["${var.ssh_allowed_ip}"]
  source_tags = ["ssh-access"]
}

resource "google_compute_firewall" "https_access" {
  name = "${var.pgsql_server_name}-allow-https"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["https-access"]
}

resource "google_compute_firewall" "pgsql_access" {
  name = "${var.pgsql_server_name}-allow-pgsql"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["pgsql-access"]
}

data "template_file" "startup" {
  template = file("${path.root}/scripts/startup-script.sh")

  vars = {
    secret = "${var.pgsql_admin_pwd}"
    database = "${var.pgsql_db_name}"
    user = "${var.pgsql_admin_user}"
    }
}

#data "template_file" "northwind_roles" {
  #template = file("${path.root}/scripts/northwind-roles.sql")

  #vars = {
    #vault_secret = "${var.pgsql_vault_pwd}"
#    }
#}

resource "google_compute_instance" "pgsql_db" {
    name = var.pgsql_server_name
    machine_type = "e2-small"
    zone = var.google_zone

    boot_disk {
      initialize_params {
        image = "ubuntu-2204-lts"
      }
    }
    labels = {
        owner = var.owner
        se-region = var.se-region
        purpose = var.purpose
        ttl = var.ttl
        terraform = var.terraform
        #hc-internet-facing = var.hc-internet-facing

    }
    connection {
        type = "ssh"
        user = var.pgsql_admin_user
        host = self.network_interface[0].access_config[0].nat_ip
        timeout = "300s"
        private_key = local.privkey
    }
    provisioner "file" {
        source = "${path.root}/scripts/northwind-database.sql"
        destination = "/tmp/northwind-database.sql"
    }
    provisioner "file" {
        source = "${path.root}/scripts/northwind-roles.sql"
        destination = "/tmp/northwind-roles.sql"
    }

    network_interface {
        subnetwork = google_compute_subnetwork.vpc_subnetwork.self_link
        access_config {
        }
    }
    tags = ["pgsql-access", "https-access", "ssh-access"]

    metadata = {
        sshKeys = "${var.pgsql_admin_user}:${local.pubkey}"
    }
    metadata_startup_script = data.template_file.startup.rendered
}