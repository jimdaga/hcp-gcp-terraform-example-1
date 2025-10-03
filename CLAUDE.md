# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Terraform project demonstrating a multi-environment, multi-region infrastructure pattern for HCP-GCP deployments. The architecture uses YAML-based configuration files to drive infrastructure provisioning.

### Key Architectural Patterns

1. **YAML-Driven Configuration**: Each environment/region directory contains YAML files (e.g., `jdagosti.yaml`, `canary.yaml`) that define stack configurations. Each YAML file represents a separate stack instance.

2. **Dynamic Module Instantiation**: The `main.tf` files use `for_each` with `fileset()` and `yamldecode()` to:
   - Discover all `*.yaml` files in the directory
   - Parse each YAML file into a configuration object
   - Create a module instance for each configuration
   - Example: `module.hcp_gcp_regional_stack["jdagosti"]` and `module.hcp_gcp_regional_stack["canary"]`

3. **Directory Structure**:
   ```
   environments/
     <env>/
       region/<region>/        # Regional resources (VPC, GKE)
         main.tf               # Uses local.region variable (set per region)
         *.yaml                # Stack configs (no region field needed)
       global/<service>/       # Global resources (DNS, API Gateway)
   modules/
     hcp-gcp-regional-stack/  # Reusable module for regional stacks
   ```

4. **Region Management**: The `region` is defined as a local variable in each regional `main.tf` file (e.g., `local.region = "us-central1"`), not in individual YAML files. This ensures all stacks in a directory deploy to the same region.

## Working with Terraform

### Standard Commands
```bash
terraform init
terraform plan
terraform apply
```

### YAML Configuration Structure

Stack YAML files must include:
- `stack_name`: Identifier for the stack
- `project`: Object with `existing` boolean
- `gke`: Object with `mode` (combined/split) and `type` (autopilot/standard)
- `vpc`: Object with `cidr` and `subnet` list

The `region` field should NOT be in YAML files - it's set per-directory in `main.tf`.

### Module Variable Requirements

The `hcp-gcp-regional-stack` module expects:
- `for_each` over lists of objects (like `vpc.subnet`) must use map conversion:
  ```hcl
  for_each = { for idx, subnet in var.vpc.subnet : subnet.name => subnet }
  ```
  NOT `toset()` which doesn't work with objects.
