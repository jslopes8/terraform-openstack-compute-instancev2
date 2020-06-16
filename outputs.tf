output "fixed_ip_v4" {
    value = "${openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4}"
}

