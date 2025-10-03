output "config_summary" {
  value = {
    region     = var.region
    stack_name = var.stack_name
    project    = var.project
    gke        = var.gke
    vpc        = var.vpc
  }
}

output "vpc_cidr" {
  value = var.vpc.cidr
}
