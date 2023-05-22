output "vm_instance"{
    description = "Description of the VM instance"
    value       = { for k, v in var.vm_instances : k => v }
}