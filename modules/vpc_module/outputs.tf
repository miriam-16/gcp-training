output "vpc_network"{
    description = "Description of the vpc_network"
    value       = { for k, v in var.vpc_networks : k => v }
}

output "vpc_network_name"{
    description = "Description of the vpc_network_name"
    //value       = {for k, v in var.vpc_networks : k => v.name}
    value = var.vpc_networks["vpc1"].name
}