resource "google_compute_instance" "vm_instance" {
    for_each = var.vm_instances
        name         = lookup(each.value, "name",each.key)
        machine_type = lookup(each.value, "machine_type","e2-micro")
        #optional
        zone         = lookup(each.value, "zone",null)
        tags         = lookup(each.value, "tags",null)
        boot_disk {
            initialize_params {
                image = lookup(each.value.boot_disk.inizialize_params, "image", "debian-cloud/debian-11")
            }
        }

        network_interface {
            subnetwork = each.value.network_interface.subnetwork
            network =  each.value.network_interface.network
            subnetwork_project = each.value.network_interface.subnetwork_project
            access_config{
                nat_ip                  = lookup(each.value.network_interface.access_config, "nat_ip", null)
                public_ptr_domain_name  = lookup(each.value.network_interface.access_config, "public_ptr_domain_name", null)
                network_tier            = lookup(each.value.network_interface.access_config, "network_tier", null)
            }
        }
}
