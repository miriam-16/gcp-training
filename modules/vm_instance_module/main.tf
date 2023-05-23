/*module "vpc_module" {
  source = "../vpc_module"
  vpc_networks = var.vpc_networks
}*/

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
/*
resource "google_compute_network" "vpc_network" {
    for_each = var.vm_instances
        name                    = lookup(each.value.vpc_networks, "name","terraform-network")
        auto_create_subnetworks = lookup(each.value.vpc_networks,"auto_create_subnetworks",true)
}*/

/*
resource "google_compute_firewall" "default" {
    for_each = { for k in flatten([
        for key, vm in var.vm_instances: [
            for key_fw, firewall in vm.firewall : [
                for key_fwa, allow in firewall.allows :{
                    vm_key  = key
                    fw_key  = key_fw
                    fwa_key = key_fwa
                    allow   = allow
                }
            ]
        ]
    ]) :"${k.vm_key}_${k.fw_key}_${k.fwa_key}" => k}

    name    = lookup(each.value.frw, "name")
    network = google_compute_network.default.name

    dynamic "allow" {
        for_each = lookup(each.value, "allow", [])
        content{
            protocol = allow.value.protocol
            ports    = allow.value.ports
        }
    }

    source_tags = lookup(each.value.frw, "source_tags", [])
}*/
