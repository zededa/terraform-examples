<div align="center">

<img src="https://cdn-ilbjcaf.nitrocdn.com/JFDkYBqKTxfOnJhKzsDtcPuWMannnxlW/assets/images/optimized/rev-5297d6b/zededa.com/wp-content/uploads/2025/05/Zededa-Logo.svg" width="420"/>

# **Terraform Examples**

**Securely orchestrating VMs & Containers at the edge using ZEDEDA & EVE-OS**

[![ZEDEDA](https://img.shields.io/badge/Powered%20by-ZEDEDA-blue)](https://www.zededa.com)
[![EVE-OS](https://img.shields.io/badge/Runtime-EVE--OS-green)](https://github.com/lf-edge/eve)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4)](https://help.zededa.com/hc/en-us/articles/4440359495835-ZEDEDA-Terraform-Provider)

</div>

---

## Overview

This repository contains terraform code examples for the ZEDEDA provider.

---

## What This Repo Contains

- ✅ 1-Infra-sjf.tf    - contains the ZEDEDA elements which tend to be more static in nature. Projects, Images, Datastores, EVE Images, Networks (For EVE management)
- ✅ 2-Brand_Models.tf - shows how to create Brands and Models for hardware needed in the Models marketplace. 
- ✅ 3-EdgeNodes.tf    - Creates the edge nodes - required so when they phone home a matching entry exists to allow onboarding. 
- ✅ 4-NetworkInstances.tf - Shows how to create both Switch & Local (L3) type of Network Instances where workloads will connect.
- ✅ 5-Apps-sjc.tf     - Where you define applications to populate the ZEDEDA Marketplace. Includes: sizing, type, Interfaces, Disks, ... and ACLs. 
- ✅ 6-Instance-Deploy-sjf.tf - Terraform code used to deploy the VMs and Containers. Includes: Edge node where to deploy, Network Instances to connect interfaces, cloud-init to use, 

---

## Architecture

```text
┌─────────────────────────────┐
│        ZEDEDA Cloud         │
│  (Control & Management)     │
└─────────────┬───────────────┘
              │ Secure Control Plane (API, ZCLI, Terraform)
┌─────────────▼───────────────┐
│           EVE-OS             │
│  (Secure Edge Runtime)       │
├─────────────┬───────────────┤
│   VMs       │  Containers   │
│   K8s       │  AI / CV Apps │
└─────────────┴───────────────┘
              │
      Edge Networks / VLANs
              │
     Cameras • Sensors • PLCs
```

---

## Repository Structure

```bash
.
├── 1-Infra-sjc.tf
├── 2-Brand_Models.tf
├── 3-EdgeNodes-sjc.tf
├── 4-NetworkInstances-sjc.tf
├── 5-Apps-sjc.tf
├── 6-Instances-Deploy-sjc.tf
├── cloud-init-samples
│   ├── cisco-config-sample.txt
│   ├── container-sample.txt
│   ├── ubuntu-24-sample.txt
│   └── win-2025-sample.txt
├── provider.tf
├── variables.tf
└── versions.tf
```

---

## Getting Started

### Prerequisites

* ZEDEDA account
* Terraform ≥ 1.5
* Edge hardware or virtual EVE node
* ZEDEDA Terraform provider configured

### Quick Start

```bash
* You must tweak the files to reflect your declared state.
terraform init
terraform plan
terraform apply
```

---

## Workloads

* Virtual Machines (Linux / Windows)
* Containers (Docker / OCI)
* Kubernetes (single & multi-node) - TBD

---

## Sample Brands and Hardware Models

* ZEDEDA is hardware agnostic and supports x86, ARM, RISC(limited)
* Sample server hardware model shown & w/ SR-IOV
* Intel NUC Model shown
* Virtual EVE nodes (KVM)

---

## References

* ZEDEDA Documentation: [https://docs.zededa.com](https://docs.zededa.com)
* EVE-OS: [https://github.com/lf-edge/eve](https://github.com/lf-edge/eve)
* Terraform Provider: [https://registry.terraform.io/providers/zededa/zedcloud](https://registry.terraform.io/providers/zededa/zedcloud)

---

## Contributing

Contributions, issues, and discussions are welcome.

If you’re using this repo for a demo or PoC, **fork it and adapt freely**.

---

## License

Apache 2.0 — see `LICENSE` file for details.

---

<div align="center">

**Built for the Edge. Designed for Scale. Secured by Default.**

</div>
