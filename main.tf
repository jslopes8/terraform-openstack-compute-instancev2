resource "openstack_compute_instance_v2" "instance" {
    count   = var.instance_count 

    name            = var.instance_count > 1 || var.use_num_suffix ? format("%s-%d", var.name, count.index + 1) : var.name
    image_id        = "${var.image_id}"
    flavor_name     = "${var.flavor_name}"
    key_pair        = "${var.key_pair}"
    security_groups = "${var.security_groups}"
    user_data       = "${var.user_data}"
    #floating_ip     = "${var.floating_ip}"

    dynamic "block_device" {
        for_each    = var.block_device
        content {
            uuid                    = lookup(block_device.value, "uuid", null)
            source_type             = lookup(block_device.value, "source_type", null)
            destination_type        = lookup(block_device.value, "destination_type", "local")
            boot_index              = lookup(block_device.value, "boot_index", null)
            volume_size             = lookup(block_device.value, "volume_size", null)
            delete_on_termination   = lookup(block_device.value, "delete_on_termination", null)
        }
    }

    dynamic "network" {
        for_each    = var.network
        content {
            name            = lookup(network.value, "name", null)
            uuid            = lookup(network.value, "uuid", null)
            port            = lookup(network.value, "port", null)
            access_network  = lookup(network.value, "access_network", null)
            fixed_ip_v4     = lookup(network.value, "fixed_ip_v4", null)
        }
    }
}

resource "openstack_compute_floatingip_associate_v2" "ip_associate" {
    count   = var.create ? length(var.floating_ip_associate) : 0

    floating_ip = var.floating_ip_associate[count.index]["floating_ip"]
    instance_id = "${openstack_compute_instance_v2.instance.*.id[count.index]}"
}
