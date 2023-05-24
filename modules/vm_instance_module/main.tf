resource "google_compute_instance" "vm_instance" {
    for_each = var.vm_instances
        name            = lookup(each.value, "name", each.key)
        machine_type    = lookup(each.value, "machine_type","e2-micro")
        #optional
        zone            = lookup(each.value, "zone",null)
        tags            = lookup(each.value, "tags",null)
        boot_disk {
            initialize_params {
                image   = lookup(each.value.boot_disk.inizialize_params, "image", "debian-cloud/debian-11")
            }
        }


        dynamic "network_interface" {
            for_each = {for key, value in each.value.network_interfaces : key => value}
            content{
                subnetwork          = network_interface.value.subnetwork
                network             = network_interface.value.network
                subnetwork_project  = network_interface.value.subnetwork_project
                access_config{
                    nat_ip                  = lookup(network_interface.value.access_config, "nat_ip", null)
                    public_ptr_domain_name  = lookup(network_interface.value.access_config, "public_ptr_domain_name", null)
                    network_tier            = lookup(network_interface.value.access_config, "network_tier", null)
                }
            }
        }
}


resource "google_compute_disk" "default" {
    for_each = {for k in flatten([
        for key, vm in var.vm_instances : [
            for key_disk, disk in vm.attached_disks : {
                vm_key      = key
                disk_key    = key_disk
                disk        = disk
            }
        ]
    ]) : "${k.vm_key}_${k.disk_key}" => k}

    name  = each.value.disk.name
    type  =  lookup(each.value.disk, "type", "pd-ssd")
    zone  = lookup(each.value.disk, "zone","eu-west8-a")
    image = lookup(each.value.disk, "image", "debian-11-bullseye-v20220719")
    labels = lookup(each.value, "labels", null)
    physical_block_size_bytes = each.value.disk.physical_block_size_bytes
}

resource "google_compute_attached_disk" "default" {
    for_each = {for k in flatten([
        for key, vm in var.vm_instances : [
            for key_disk, disk in vm.attached_disks : {
                vm_key      = key
                disk_key    = key_disk
                disk        = disk
            }
        ]
    ]) : "${k.vm_key}_${k.disk_key}" => k}
    disk     = google_compute_disk.default["${each.key}"].id
    instance = google_compute_instance.vm_instance["${each.value.vm_key}"].id
}
