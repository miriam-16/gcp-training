resource "google_compute_instance" "vm_instance" {
    for_each = var.vm_instances
        name         = lookup(each.value, "name",each.key)
        machine_type = lookup(each.value, "machine_type","e2-micro")
        #optional
        #zone         = lookup(each.value, "zone",null)
        tags         = lookup(each.value, "tags",null)
        boot_disk {
            initialize_params {
                image = lookup(each.value.boot_disk.inizialize_params, "image", "debian-cloud/debian-11")
            }
        }

        network_interface {
            network = lookup(each.value.network_interface, "network","default")
            access_config {
            }
        }
}

resource "google_compute_network" "vpc_network" {
    for_each = var.vm_instances
        name                    = lookup(each.value.vpc_networks, "name","terraform-network")
        auto_create_subnetworks = lookup(each.value.vpc_networks,"auto_create_subnetworks",true)
}