resource "google_compute_network" "vpc_network" {
    for_each = var.vpc_networks
        project                 = each.value.project
        name                    = each.value.name
        description             = lookup(each.value, "description", null) 
        auto_create_subnetworks = lookup(each.value, "auto_create_subnetworks", true)
        mtu                     = lookup(each.value, "mtu", 1460)
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
    for_each = { for k in flatten([
        for key, vpc in var.vpc_networks : [
            for key_sn, subnetwork in vpc.subnetworks : {
                    vpc_key    = key
                    sn_key     = key_sn
                    subnetwork = subnetwork
            }
        ]
    ]) : "${k.vpc_key}_${k.sn_key}" => k} 

    name          = lookup(each.value.subnetwork, "name","test-subnetwork-false")
    ip_cidr_range = lookup(each.value.subnetwork,"ip_cidr_range","10.2.0.0/16")
    region        = lookup(each.value.subnetwork, "region","us-central1")
    network       = google_compute_network.vpc_network[each.value.vpc_key].id
    secondary_ip_range {
        range_name    = lookup(each.value.subnetwork.secondary_ip_range, "range_name","tf-test-secondary-range-update1")
        ip_cidr_range = lookup(each.value.subnetwork.secondary_ip_range,"ip_cidr_range","192.168.10.0/24")
    }
}

