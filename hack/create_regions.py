#!/usr/bin/env python3
"""
Script to create region directory structure from regions.yaml
"""

import yaml
import os
from pathlib import Path


def load_template(template_name):
    """Load a template file from the hack/templates directory."""
    template_path = Path(__file__).parent / "templates" / template_name
    with open(template_path, "r") as f:
        return f.read()


def main():
    print("Creating region directory structure from regions.yaml...")

    # Load the main.tf template
    template = load_template("region-main.tf.tmpl")

    with open("regions.yaml", "r") as f:
        regions = yaml.safe_load(f)

    for env, region_list in regions.items():
        for region in region_list:
            path = f"environments/{env}/region/{region}"
            os.makedirs(path, exist_ok=True)

            main_tf = f"{path}/main.tf"
            if not os.path.exists(main_tf):
                with open(main_tf, "w") as tf:
                    # Replace the {region} placeholder while preserving ${...} for Terraform
                    content = template.replace("{region}", region)
                    tf.write(content)
                print(f"Created {main_tf}")
            else:
                print(f"Skipped {main_tf} (already exists)")

    print("Region directory structure creation complete!")


if __name__ == "__main__":
    main()
