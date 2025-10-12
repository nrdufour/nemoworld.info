---
date: 2025-10-12T00:00:00-00:00
title: SnowPea
project_type: Software
project_icon: default.png
started: 2024
desc: NixOS Flake for managing a 16-machine homelab infrastructure with K3s cluster on ARM and x86 hardware.
unmaintained: false
draft: false
---

## A NixOS Flake for Homelab Management

Because managing a homelab with NixOS flakes is easier than remembering which Pi is which.

SnowPea is my comprehensive NixOS Flake configuration for managing an entire homelab infrastructure across ARM-based single-board computers and x86 machines. The project demonstrates declarative infrastructure management at scale with 16 machines running everything from Kubernetes clusters to standalone services.

### Infrastructure

The homelab consists of:

* **K3s Kubernetes Cluster**: 3 Orange Pi 5 Plus controllers and 6 Raspberry Pi 4 workers
* **Standalone Services**: Various additional Pis and x86 boxes running dedicated services
* **Multi-Architecture Support**: Seamlessly handles both ARM and x86 hardware

### Key Features

* **Declarative Configuration**: Everything defined in NixOS flakes for reproducibility
* **Remote Deployment**: Simple deployment via `just nix-deploy` command
* **SD Card Image Generation**: Automated creation of bootable images for different SBCs
* **Secrets Management**: SOPS integration for secure credential handling
* **Centralized Management**: Single source of truth for all machine configurations

### Tech Used

* **NixOS 25.05** with Flakes
* **K3s** for lightweight Kubernetes
* **SOPS** for secrets management
* **Just** for task automation
* **Orange Pi 5 Plus** and **Raspberry Pi 4** hardware

### Project Goals

SnowPea serves multiple purposes:
* Production homelab infrastructure management
* Learning platform for advanced Nix/NixOS techniques
* Experimentation with infrastructure as code patterns
* Documentation of real-world NixOS deployment practices

Check out the project on [GitHub](https://github.com/nrdufour/snowpea) to see the full configuration and learn more about managing a NixOS-based homelab.
