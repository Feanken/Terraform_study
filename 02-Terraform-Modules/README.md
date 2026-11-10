# Lab 02 — Building Reusable Terraform Modules on Huawei Cloud

## 1. Overview

This lab demonstrates how to organize Terraform configurations into reusable modules using Huawei Cloud.

The project focuses on improving Terraform code structure, modularity, maintainability, and reusability.

**Objectives:**
- Understand Terraform modules and their purpose.
- Differentiate root modules from child modules.
- Build a reusable networking module.
- Pass variables between Terraform modules.
- Retrieve resource information using module outputs.
- Understand Terraform provider requirements in child modules.
- Manage module-based infrastructure through Terraform.

## 2. Architecture

```text
Terraform Root Module
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    │
    └── networking/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
            │
            └── Huawei Cloud VPC
```

The root module calls a reusable child module responsible for provisioning a Huawei Cloud VPC.

## 3. Resource Configuration

| Resource | Configuration |
|---|---|
| Cloud Provider | Huawei Cloud |
| Region | AP-Jakarta (`ap-southeast-4`) |
| Infrastructure Tool | Terraform |
| Module Type | Local Child Module |
| Module Name | networking |
| Cloud Resource | Virtual Private Cloud (VPC) |
| Module Output | VPC ID |

## 4. Implementation

1. Created an independent Terraform project directory.
2. Created a `modules/networking` child module.
3. Defined the Huawei Cloud VPC resource inside the networking module.
4. Configured input variables for the VPC name and CIDR.
5. Configured output values to expose the VPC ID.
6. Called the networking module from the root configuration.
7. Declared the Huawei Cloud provider requirements in the child module.
8. Initialized the Terraform project using `terraform init`.
9. Validated the configuration using `terraform validate`.
10. Reviewed the infrastructure using `terraform plan`.
11. Created the VPC using `terraform apply`.
12. Verified the resource using Terraform state and outputs.

## 5. Module Configuration

Example root module:

```hcl
module "networking" {
  source = "./modules/networking"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}
```

Example child module resource:

```hcl
resource "huaweicloud_vpc" "this" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}
```

Example root output:

```hcl
output "networking_vpc_id" {
  value = module.networking.vpc_id
}
```

The exact configuration may vary depending on the implemented variable and output names.

## 6. Troubleshooting

### Issue 1 — Incorrect Provider Source

Terraform initially attempted to retrieve the Huawei Cloud provider from the wrong namespace.

**Cause:**

The child module did not explicitly declare its required provider source.

**Resolution:**

Added a `required_providers` block to the child module:

```hcl
terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
    }
  }
}
```

### Issue 2 — Duplicate VPC Resource

A VPC resource was defined in both the root module and the child module.

**Cause:**

The root configuration still contained a direct VPC resource declaration, resulting in unnecessary duplication and undeclared variable references.

**Resolution:**

Removed the duplicate root resource and retained the VPC resource inside the networking module.

## 7. Verification

Terraform state was used to verify that the VPC was managed by the child module.

```text
module.networking.huaweicloud_vpc.this
```

The VPC ID was exposed through the root module output.

## 8. Results

- Successfully created a reusable Terraform networking module.
- Provisioned a Huawei Cloud VPC through a child module.
- Configured module inputs and outputs.
- Resolved Terraform provider source configuration issues.
- Identified and corrected duplicate resource declarations.
- Verified module-managed resources through Terraform state.

## 9. Key Learnings

- Root modules vs child modules.
- Terraform module reusability.
- Module input and output management.
- Terraform provider inheritance and source declarations.
- Terraform code organization.
- Infrastructure troubleshooting.
- Module-based infrastructure lifecycle management.
