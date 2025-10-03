# HCP-GCP Terraform Example

A prototype demonstrating an opinionated Terraform code structure that uses YAML configuration files to provide a user-friendly interface for non-Terraform users.

## Overview

This project showcases a pattern for managing multi-environment, multi-region infrastructure where:
- **Terraform experts** create and maintain reusable modules
- **Non-Terraform users** can deploy infrastructure using simple YAML configuration files
- Infrastructure is organized by environment, region, and service

## Key Features

### YAML-Driven Configuration

Instead of writing Terraform code, users create YAML files that define their infrastructure requirements:

```yaml
stack_name: "jdagosti"
project:
  existing: false
gke:
  mode: "combined"
  type: "autopilot"
vpc:
  cidr: "10.10.0.0/16"
  subnet:
    - { name: "infra", cidr: "10.10.1.0/24" }
```

### Dynamic Module Instantiation

Each YAML file in a directory automatically creates a separate infrastructure stack. For example:
- `jdagosti.yaml` ’ `module.hcp_gcp_regional_stack["jdagosti"]`
- `canary.yaml` ’ `module.hcp_gcp_regional_stack["canary"]`

This is achieved through Terraform's `for_each` with `fileset()` and `yamldecode()` functions.

### Organized Directory Structure

```
environments/
  stg/
    region/
      us-central1/          # All stacks in this dir deploy to us-central1
        main.tf             # Orchestration layer
        jdagosti.yaml       # Stack configuration
        canary.yaml         # Stack configuration
      us-east2/
        main.tf
        canary.yaml
    global/
      apigateway/
      dns/
modules/
  hcp-gcp-regional-stack/   # Reusable Terraform module
```

## Usage

### For Non-Terraform Users

1. Navigate to the appropriate environment and region directory:
   ```bash
   cd environments/stg/region/us-central1
   ```

2. Create a new YAML file with your desired configuration:
   ```bash
   cp jdagosti.yaml mystack.yaml
   # Edit mystack.yaml with your settings
   ```

3. Apply the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

Your stack will be created automatically alongside existing stacks.

### For Terraform Developers

- Reusable modules are in `modules/`
- Each environment's `main.tf` handles YAML discovery and module instantiation
- Region-specific settings are defined in each regional `main.tf` (e.g., `local.region = "us-central1"`)

## Benefits of This Approach

1. **Separation of Concerns**: Infrastructure experts build modules; users configure deployments
2. **Familiar Syntax**: YAML is more approachable than HCL for configuration
3. **DRY Principle**: Single module definition serves multiple stack instances
4. **Scalability**: Adding new stacks is as simple as creating a new YAML file
5. **Type Safety**: Terraform validates YAML against module variable definitions

## Prototype Status

This is a proof-of-concept demonstrating the viability of this pattern. Current implementation uses `null_resource` with `local-exec` provisioners for demonstration purposes.
