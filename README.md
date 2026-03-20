# gitops-aws-example
Terraform for AWS infrastructure supporting the GitOps pipeline

## GenAI Usage

This repository made use of GenAI through Anthropic's Claude.

## Overview

This repository contains Terraform code to provision the AWS infrastructure
required by the GitOps pipeline:

- **ECR repositories** for base images and application images
- **GitHub Actions OIDC** for keyless authentication from CI/CD workflows
- **IAM roles and policies** scoped to the minimum required permissions

## Usage

```bash
cd terraform/environments/base
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## Modules

| Module | Purpose |
|--------|---------|
| `ecr` | ECR repository with lifecycle policies and scan-on-push |
| `gha_sso` | GitHub Actions OIDC provider + IAM role for CI/CD |
