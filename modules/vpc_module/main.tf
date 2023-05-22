resource "google_compute_network" "vpc_network" {
    for_each = var.vpc_networks
        project                 = each.value.project
        name                    = each.value.name
        description             = lookup(each.value, "description", null) 
        auto_create_subnetworks = lookup(each.value, "auto_create_subnetworks", true)
        mtu                     = lookup(each.value, "mtu", 1460)
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
    //TODO: dA QUI
    /*for_each = { for k in flatten([
        for key, vpc in var.vpc_networks : [
            for key_sn, subnetwork in vpc.subnetworks : [
                for key_sec, secondary_ip_range in subnetwork.secondary_ip_range :{
                    vpc_key    = key
                    sn_key     = key_sn
                    sec_key    = key_sec
                    sec_ip_range = secondary_ip_range
                }
            ]
        ]
    ]) : "${k.vpc_key}_${k.sn_key}_${k.sec_key}" => k} */
    name          = lookup(each.value.sn_key, "name","test-subnetwork")
    ip_cidr_range = lookup(each.value.sn_key,"ip_cidr_range","10.2.0.0/16")
    region        = lookup(each.value.sn_key, "region","us-central1")
    network       = google_compute_network.custom-test.id
    secondary_ip_range {
        range_name    = lookup(each.value.sec_key, "range_name","tf-test-secondary-range-update1")
        ip_cidr_range = lookup(each.value.sec_key,"ip_cidr_range","192.168.10.0/24")
    }
}

resource "google_compute_network" "custom-test" {
    name                    = "test-network"
    auto_create_subnetworks = false
}

