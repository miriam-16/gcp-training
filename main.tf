//export GOOGLE_APPLICATION_CREDENTIALS=/home/utente/.config/gcloud/application_default_credentials.json
provider "google" {
  project = "terraform-dev-387508"
  region  = "europe-west8"
  zone    = "europe-west8-a"
}

module "google_compute_network" {
  source = "./modules/vpc_module"
  vpc_networks = var.vpc_networks
}

module "google_compute_instance" {
  source = "./modules/vm_instance_module"
  vm_instances    = var.vm_instances
  vpc_networks    = var.vpc_networks

}

output "vm_instance"{
    description = "Description of the VM instance"
    value       = { for k, v in var.vm_instances : k => v }
}

output "vpc_network"{
    description = "Description of the vpc_network"
    value       = { for k, v in var.vpc_networks : k => v }
}

output "vpc_subnetwork_id"{
    description = "Description of the vpc_subnetwork_id"
    value       = module.google_compute_network.subnet_id
}
