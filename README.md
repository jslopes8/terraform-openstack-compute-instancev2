# Terraform module to Openstack (Neutron v10)
Create Instancia VM

O codigo irá prover os seguintes recursos no Openstack.
* [Instance](https://www.terraform.io/docs/providers/openstack/r/compute_instance_v2.html)
* [Floating IP Associate](https://www.terraform.io/docs/providers/openstack/r/compute_floatingip_associate_v2.html)


The `block_device` block supports:
- `uuid` - (Required unless source_type is set to "blank" ) The UUID of the image, volume, or snapshot. Changing this creates a new server.

- `source_type` - (Required) The source type of the device. Must be one of "blank", "image", "volume", or "snapshot". Changing this creates a new server.

- `volume_size` - The size of the volume to create (in gigabytes). Required in the following combinations: source=image and destination=volume, source=blank and destination=local, and source=blank and destination=volume. Changing this creates a new server.

- `boot_index` - (Optional) The boot index of the volume. It defaults to 0. Changing this creates a new server.

- `destination_type` - (Optional) The type that gets created. Possible values are "volume" and "local". Changing this creates a new server.

- `delete_on_termination` - (Optional) Delete the volume / block device upon termination of the instance. Defaults to false. Changing this creates a new server.


The `network` block support:
- `uuid` - (Required unless port or name is provided) The network UUID to attach to the server. Changing this creates a new server.

- `name` - (Required unless uuid or port is provided) The human-readable name of the network. Changing this creates a new server.

- `port` - (Required unless uuid or name is provided) The port UUID of a network to attach to the server. Changing this creates a new server.

- `fixed_ip_v4` - (Optional) Specifies a fixed IPv4 address to be used on this network. Changing this creates a new server.

- `access_network` - (Optional) Specifies if this network should be used for provisioning access. Accepts true or false. Defaults to false.


The `floating_ip_associate` block support:
- `floating_ip`, (Required) The floating IP to associate.



## Usage
Example create basic instance

```hcl
module "create_vm" {
    source  = "./modules/computer/"

    # amount of the instance that will create, default 1.
    instance_count  = "2"

    # Please provide the initial hostname for the instance
    # Flavors manage the sizing for the compute, memory and storage capacity of the instance.
    # A key pair allows you to SSH into your newly created instance
    name        = "vm-terraform-openstack
    flavor_name = "large.16GB"
    image_id    = "e22b1feb-ed2b-4f2d-b227-273eb3630630"
    key_pair    = "dcadmin_key"

    # Bootstrap script (support cloud-init)
    # You can customize your instance after it has launched using the options available 
    # here. "Customization Script" is analogous to "User Data" in other systems.
    user_data   = data.template_file.user_data_infra.rendered

    # Networks provide the communication channels for instances in the cloud.
    network = [
        {
            name    = rede-privada	
        }
    ]

    # Select the security groups to launch the instance in. Support list of string
    security_groups = [ "default"  ]   
}
```

For allocation IP public
```hcl
module "create_vm" {
    source  = "./modules/computer/"

...

    floating_ip_associate   = [ 
        { 
            floating_ip = "187.18.60.64"
        }
    ]
}
```
## Variable Inputs

| Name | Descrição | Type | Default | Required | 
| ---- | --------- | ---- | ------- | -------- |
| name | The name of your instance that it will be created | `string` | "NO" | "YES" |
| instance_count | The amount of the instance it will be created | `number` | '1' | "NO" |
| image_id | The name of the desired image for the server. Changing this creates a new server | `string` | "NO" | "YES" |
| flavor_name | The name of the desired flavor for the server. Changing this resizes the existing server | `string` | "NO" | "YES" |
| security_groups | An array of one or more security group names or ids to associate with the server | `list` | "NO" | "YES" |
| user_data | The user data to provide when launching the instance. Changing this creates a new server | `string` | "NO" | "YES" |


## Variable Outputs

| Name | Descrição | 
| ---- | --------- |
| fixed_ip_v4 | The specific IP address to direct traffic to. | 