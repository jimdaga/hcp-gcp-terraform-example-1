locals {
  # 1. Discover all YAML files in the configs directory
  config_files = fileset("${path.module}", "*.yaml")

  # 2. Decode all YAML files into a single map, using the filename (e.g., "bob") as the key
  user_configs = {
    for file_path in local.config_files :
    trimsuffix(basename(file_path), ".yaml") => yamldecode(file(file_path))
  }
  region = "us-central1"
}

resource "null_resource" "example" {}

# The module block uses 'for_each' to create multiple instances.
# Each instance is named after the YAML file (e.g., module.hcp_gcp_regional_stack["bob"]).
# Module ref managed in regions.yaml (stg.module_ref)
module "hcp_gcp_regional_stack" {
  for_each = local.user_configs

  source = "git::https://github.com/jimdaga/hcp-gcp-terraform-example-1.git//modules/hcp-gcp-regional-stack?ref=72fd91acb430cdc3cc2c515dfe6101dd0020b5f6"

  # Pass the configuration for the current user (each.value) directly
  # to the corresponding module arguments.
  region     = local.region
  stack_name = each.value.stack_name
  project    = each.value.project
  gke        = each.value.gke
  vpc        = each.value.vpc
}

output "mocked_outputs" {
  # Iterate over the created module instances to show the output for each user.
  value = {
    for name, instance in module.hcp_gcp_regional_stack :
    name => instance.config_summary
  }
}
