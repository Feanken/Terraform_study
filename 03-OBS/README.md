# Lab 03 — Provisioning Huawei Cloud OBS Using Terraform

## 1. Overview

This lab demonstrates how to provision and manage an Object Storage Service (OBS) bucket on Huawei Cloud using Terraform.

**Objectives:**
- Understand Huawei Cloud Object Storage Service (OBS).
- Provision an OBS bucket using Terraform.
- Configure private bucket access and storage class.
- Use Terraform variables and outputs.
- Validate infrastructure configurations before deployment.
- Verify and clean up cloud resources using Terraform.

## 2. Architecture

Terraform CLI → Huawei Cloud Provider → OBS Bucket (AP-Jakarta)

The OBS bucket is provisioned using Terraform with private ACL and STANDARD storage class.

## 3. Resource Configuration

| Resource | Configuration |
|---|---|
| Cloud Provider | Huawei Cloud |
| Region | AP-Jakarta (`ap-southeast-4`) |
| Service | Object Storage Service (OBS) |
| Bucket Name | terraform-sisco-test |
| Access Control | Private |
| Storage Class | STANDARD |
| Infrastructure Tool | Terraform |

## 4. Implementation

1. Created a dedicated Terraform project directory.
2. Configured the Huawei Cloud Terraform provider.
3. Defined the OBS bucket resource.
4. Configured input variables and outputs.
5. Initialized the project using `terraform init`.
6. Validated the configuration using `terraform validate`.
7. Reviewed the deployment using `terraform plan`.
8. Provisioned the bucket using `terraform apply`.
9. Verified the bucket through Terraform outputs and Huawei Cloud Console.
10. Cleaned up the resource using `terraform destroy`.

## 5. Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform state list
terraform output
terraform plan -destroy
terraform destroy
```

## 6. Results

- Successfully provisioned an OBS bucket using Terraform.
- Configured private bucket access.
- Retrieved bucket information using Terraform outputs.
- Verified the resource through Huawei Cloud Console.
- Removed the OBS bucket after completing the lab.

## 7. Key Learnings

- Infrastructure as Code (IaC) fundamentals.
- Terraform provider and resource configuration.
- Terraform variables and outputs.
- Object storage provisioning and access control.
- Terraform state management and resource lifecycle.
- Cloud resource cleanup to avoid unnecessary costs.
