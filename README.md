# IaC Testing Framework for Azure AKS

## Overview
Automated testing framework for Terraform-based AKS deployments, covering:
- Static analysis (TFLint)
- Security compliance (Checkov)
- Runtime validation (Terratest)

## Setup
1. **Prerequisites**:
   - Azure CLI (`az login`)
   - Terraform v1.0+
   - Go (for Terratest)

2. **Deploy**:
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   