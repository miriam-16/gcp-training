provider "google" {
  project = "terraform-dev-387508"
  region  = "europe-west8"
  zone    = "europe-west8-a"
}

module "google_compute_instance" {
  source = "./modules/vm_instance_module"
  vm_instances = var.vm_instances
}