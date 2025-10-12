---
date: 2025-10-12T13:18:45-04:00
title: Home-Ops
project_type: Software
project_icon: default.png
started: 2022
desc: GitOps-managed Kubernetes homelab for self-hosting services, home automation, and infrastructure experimentation.
unmaintained: false
draft: false
---

## Kubernetes Homelab with GitOps

Because paying for cloud services is for people who hate tinkering at 2 AM.

Home-Ops is my fully declarative Kubernetes-based homelab infrastructure, managed through GitOps principles. It runs a collection of self-hosted services and home automation tools, all managed through code and automated deployments. The philosophy is simple: "If it's not in Git, it doesn't exist. If it's not automated, it's not production-ready."

### Self-Hosted Services

The cluster runs various services for daily use:

* **Miniflux** - RSS reader for staying up to date
* **SearXNG** - Private search engine
* **Wallabag** - Read-it-later service
* **Mealie** - Recipe manager
* **Wiki.js** - Personal documentation wiki
* **Homepage** - Unified dashboard for all services

### Home Automation Stack

Monitoring and automation services include:

* **Grafana** - Metrics visualization
* **InfluxDB2** - Time-series database
* **RTL433** - Wireless sensor data collection
* **RTLAMR2MQTT** - Utility meter monitoring
* **NUT UPS Daemon** - Uninterruptible power supply management

### Tech Used

* **Kubernetes** - Container orchestration
* **ArgoCD** - GitOps continuous deployment
* **SOPS + Age** - Encrypted secrets management
* **External Secrets** - Kubernetes secret injection
* **Renovate** - Automated dependency updates
* **NixOS** - Machine configuration (via companion [SnowPea](/projects/snowpea/) repo)

### Architecture

Home-Ops works in tandem with my [SnowPea](/projects/snowpea/) NixOS configuration to provide a complete infrastructure-as-code solution. While SnowPea handles machine provisioning and OS configuration, Home-Ops manages the Kubernetes workloads and application deployments using GitOps workflows.

The entire infrastructure is version-controlled, automatically updated, and can be rebuilt from scratch using declarative configurations.

---

Check out the project on [GitHub](https://github.com/nrdufour/home-ops) to explore the full configuration and learn more about building a GitOps-managed homelab.
