variable "create" {
    type    = bool
    default = true
}
variable "instance_count" {
    type    = number
    default = 1
}
variable "name" {
    type    = string
}
variable "user_data" {
    type    = string
}
variable "image_id" {
    type    = string
}
variable "flavor_name" {
    type    = string
}
variable "key_pair" {
    type    = string
}
variable "security_groups" {
    type    = list(string)
    default = []
}
variable "block_device" {
    type    = list(map(string))
    default = []
}
variable "use_num_suffix" {
    type        = bool
    default     = false
}
variable "network" {
    type    = list(map(string))
    default = []
}
variable "floating_ip_associate" {
    type    = list(map(string))
    default = []
}
