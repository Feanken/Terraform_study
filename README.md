# Terraform Study — Huawei Cloud Infrastructure as Code

## Overview

This repository contains my hands-on learning projects focused on Infrastructure as Code (IaC) using Terraform and Huawei Cloud.

The purpose of this repository is to strengthen my practical understanding of cloud infrastructure provisioning, automation, infrastructure management, and DevOps engineering practices.

Each lab is organized as an independent mini-project, covering different Huawei Cloud services and Terraform concepts.

## Learning Objectives

- Understand Infrastructure as Code fundamentals.
- Provision Huawei Cloud resources using Terraform.
- Configure cloud networking, compute, and storage services.
- Build reusable and maintainable Terraform configurations.
- Practice Terraform variables, outputs, providers, and modules.
- Understand Terraform state and resource lifecycle management.
- Improve troubleshooting and infrastructure automation skills.
- Develop hands-on experience relevant to Cloud Engineering and DevOps.

## Technology Stack

| Category | Technology |
|---|---|
| Cloud Platform | Huawei Cloud |
| Infrastructure as Code | Terraform |
| Cloud Region | AP-Jakarta (`ap-southeast-4`) |
| Operating System | Ubuntu Linux |
| Local Environment | Windows / PowerShell |
| Version Control | Git & GitHub |
| Cloud Services | ECS, VPC, Subnet, Security Group, OBS |

## Mini-Projects

| Lab | Project | Description | Status |
|---|---|---|---|
| 01 | [Huawei Cloud ECS](./01-ECS/) | Provisioning ECS, VPC, subnet, and Security Group using Terraform | Completed |
| 02 | [Terraform Modules](./02-Terraform-Modules/) | Building reusable Terraform networking modules | Completed |
| 03 | [Huawei Cloud OBS](./03-OBS/) | Provisioning and managing OBS buckets using Terraform | Completed |

## Repository Structure

```text
Terraform-Study/
├── README.md
├── .gitignore
│
├── 01-ECS/
│   ├── README.md
│   └── Terraform configuration files
│
├── 02-Terraform-Modules/
│   ├── README.md
│   ├── Terraform configuration files
│   └── modules/
│       └── networking/
│
└── 03-OBS/
    ├── README.md
    └── Terraform configuration files
```

## Getting Started

### Prerequisites

Before running these projects, make sure you have:

- Terraform installed.
- A Huawei Cloud account.
- Appropriate IAM permissions.
- Huawei Cloud access credentials.
- PowerShell or another supported terminal.

### Configure Authentication

Set Huawei Cloud credentials using environment variables.

For PowerShell:

```powershell
$env:HW_ACCESS_KEY = "YOUR_ACCESS_KEY"
$env:HW_SECRET_KEY = "YOUR_SECRET_KEY"
```

Do not hardcode actual credentials in Terraform configuration files or commit them to GitHub.

### Run a Project

Navigate to the selected project directory.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After completing the lab, review the cleanup plan and remove resources when they are no longer needed.

```bash
terraform plan -destroy
terraform destroy
```

Some projects require additional variable configuration. Refer to each project's README for details.

## Terraform Workflow

The general workflow used throughout these projects is:

```text
Write Configuration
        |
        v
Terraform Init
        |
        v
Terraform Format & Validate
        |
        v
Terraform Plan
        |
        v
Terraform Apply
        |
        v
Verify Infrastructure
        |
        v
Terraform Destroy
```

## Security Best Practices

- Never commit Huawei Cloud access keys or secret keys.
- Never upload Terraform state files to public repositories.
- Use `.gitignore` to exclude sensitive and generated files.
- Restrict Security Group rules to trusted networks.
- Review Terraform plans before applying changes.
- Avoid unnecessary cloud resource costs by cleaning up lab infrastructure.
- Use least-privilege IAM permissions whenever possible.

## Learning Outcomes

Through these mini-projects, I have practiced:

1. Provisioning cloud compute and networking infrastructure.
2. Managing ECS resources and basic lifecycle operations.
3. Structuring Terraform configurations using reusable modules.
4. Deploying object storage resources on Huawei Cloud.
5. Working with Terraform variables, outputs, and state.
6. Troubleshooting Terraform configuration errors.
7. Managing infrastructure creation and cleanup.

## Future Learning

Future projects may include:

- Terraform remote state management.
- Advanced networking infrastructure.
- Load Balancer provisioning.
- RDS database provisioning.
- Terraform environment separation.
- Infrastructure automation through CI/CD pipelines.

## Disclaimer

This repository is intended for educational and hands-on practice purposes.

The configurations are designed for a lab environment and may require additional security, reliability, and operational controls before production use.
