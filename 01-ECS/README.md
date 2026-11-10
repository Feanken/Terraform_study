# Lab 01 — Provisioning Huawei Cloud ECS Using Terraform

## 1. Overview

This lab demonstrates how to provision and manage an Elastic Cloud Server (ECS) on Huawei Cloud using Terraform.

The project focuses on creating cloud infrastructure through Infrastructure as Code (IaC), including networking, security, compute resources, and basic ECS lifecycle operations.

**Objectives:**
- Understand Terraform fundamentals and Infrastructure as Code.
- Configure the Huawei Cloud Terraform provider.
- Provision a Virtual Private Cloud (VPC) and subnet.
- Configure Security Group rules.
- Deploy an Ubuntu 24.04 ECS instance.
- Use Terraform variables, data sources, and outputs.
- Manage ECS power operations using PowerShell.
- Understand Terraform resource lifecycle management.

## 2. Architecture

```text
Huawei Cloud — AP-Jakarta
│
└── VPC (192.168.0.0/16)
    │
    └── Subnet (192.168.1.0/24)
        │
        └── ECS — Ubuntu 24.04
            │
            └── Security Group
                ├── Inbound: SSH (TCP/22)
                └── Outbound: Allow All
```

Terraform is used to define and provision the infrastructure, while PowerShell provides a simple interface for ECS lifecycle operations.

## 3. Resource Configuration

| Resource | Configuration |
|---|---|
| Cloud Provider | Huawei Cloud |
| Region | AP-Jakarta (`ap-southeast-4`) |
| Infrastructure Tool | Terraform |
| Operating System | Ubuntu 24.04 LTS |
| ECS Specification | 1 vCPU / 1 GiB RAM |
| VPC CIDR | 192.168.0.0/16 |
| Subnet CIDR | 192.168.1.0/24 |
| Subnet Gateway | 192.168.1.1 |
| Security Group | Custom security rules |
| SSH Port | TCP 22 |
| Authentication | Password |

## 4. Implementation

1. Installed and configured Terraform on Windows.
2. Configured Huawei Cloud authentication using environment variables.
3. Initialized the Terraform project.
4. Created a VPC and subnet.
5. Created a Security Group with inbound and outbound rules.
6. Used Terraform data sources to retrieve available ECS flavors and operating system images.
7. Configured an Ubuntu 24.04 ECS instance.
8. Used Terraform variables for configurable resource settings.
9. Executed `terraform plan` to review infrastructure changes.
10. Applied the configuration using `terraform apply`.
11. Developed a PowerShell script for ECS start, stop, and reboot operations.

## 5. Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform state list
terraform output
```

## 6. ECS Lifecycle Management

The `ecs-control.ps1` PowerShell script was developed to practice managing ECS power operations.

Supported operations:
- Start ECS
- Stop ECS
- Reboot ECS

These operations demonstrate the difference between provisioning infrastructure and managing the operational lifecycle of a cloud server.

## 7. Security Considerations

- Huawei Cloud credentials are configured through environment variables rather than hardcoded into Terraform configuration.
- ECS passwords should not be committed to GitHub.
- Terraform state files should remain private because they may contain sensitive information.
- SSH access from `0.0.0.0/0` was used for learning purposes and should be restricted to trusted IP addresses in production.
- SSH key authentication is recommended for production environments.

## 8. Results

- Practiced provisioning Huawei Cloud infrastructure using Terraform.
- Created and configured VPC, subnet, and Security Group resources.
- Configured an Ubuntu ECS deployment.
- Used Terraform data sources, variables, and outputs.
- Practiced ECS lifecycle management using PowerShell.

## 9. Key Learnings

- Infrastructure as Code fundamentals.
- Terraform resource dependencies.
- Huawei Cloud networking and compute infrastructure.
- Terraform provider configuration and data sources.
- Security Group configuration.
- Infrastructure planning and deployment.
- Cloud server lifecycle management.
