resource "null_resource" "print_config" {
  provisioner "local-exec" {
    command = "echo Configuration Summary: Region=${var.region}, Stack=${var.stack_name}, VPC CIDR=${var.vpc.cidr}"
  }
}

resource "null_resource" "print_subnet" {
  for_each = { for idx, subnet in var.vpc.subnet : subnet.name => subnet }
  provisioner "local-exec" {
    command = "echo Subnet Info: Name=${each.value.name}, CIDR=${each.value.cidr}"
  }
}
