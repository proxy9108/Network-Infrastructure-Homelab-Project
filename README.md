# Network-Infrastructure-Homelab-Project
This repository documents a multi-VLAN network infrastructure designed with security-first principles, supporting both production services and development workloads across isolated network segments.
## 🎯 Project Overview

This repository documents a multi-VLAN network infrastructure designed with security-first principles, supporting both production services and development workloads across isolated network segments.

### Key Achievements
- **Network Segmentation:** 4 isolated VLANs with zone-based firewall policies
- **DNS Security:** Pi-hole filtering processing 4.88M queries/3mo, blocking 44.53% (2.1M queries)
- **Zero-Trust Access:** Tailscale integration for secure remote access without exposed ports
- **High Availability:** Virtualized infrastructure with GPU passthrough capabilities
- **Automated Management:** Scripted backups and configuration validation

## 🏗️ Architecture

### Network Topology
![Network Topology](docs/diagrams/network-topology.png)

### VLAN Structure
| VLAN | Name | Purpose | Subnet | Security Zone |
|------|------|---------|--------|---------------|
| 20 | Home | Trusted devices | 192.168.20.0/24 | Trusted |
| 30 | Guest | Visitor access | 192.168.30.0/24 | Untrusted (Internet-only) |
| 40 | Internal | Core services | 192.168.40.0/24 | Restricted (Home + Tailscale only) |
| 50 | IoT | Smart devices | 192.168.50.0/24 | Isolated (Internet-only) |

## 🛠️ Technology Stack

**Network Hardware:**
- Netgate 1100 (pfSense firewall/router)
- TP-Link TL-SG108E (Managed 802.1Q switch)
- TP-Link EAP225 (VLAN-aware access point)
- Starlink (WAN connectivity)

**Software & Services:**
- **pfSense** - Firewall, routing, DHCP
- **Pi-hole** - DNS filtering and ad-blocking
- **Tailscale** - Zero-trust remote access
- **Proxmox VE** - Virtualization platform
- **Cloudflare** - Authoritative DNS

## 🔒 Security Features

### Zero-Trust Architecture
- Internal services (VLAN 40) accept connections **only** from:
  - Home network (VLAN 20) on specific ports
  - Tailscale authenticated endpoints
- Guest and IoT networks have **no lateral access**

### Defense in Depth
- VLAN segmentation (Layer 2 isolation)
- Stateful firewall rules (Layer 3/4 filtering)
- DNS filtering (Application layer security)
- Encrypted DNS upstream (DoH/DoT)
- No inbound WAN ports exposed

### Network Monitoring
- pfSense traffic analysis
- Pi-hole query logging
- Firewall log review procedures

## 📊 Performance Metrics

**DNS Filtering (3-month period):**
- Total queries processed: 4.88M
- Blocked queries: 2.1M (44.53%)
- Average response time: <10ms

**Network Segmentation:**
- 4 isolated VLANs
- 25+ firewall rules enforcing security policies
- Zero lateral movement between untrusted zones

## 🚀 Quick Start

### Prerequisites
- Basic networking knowledge (subnetting, VLANs, firewall concepts)
- Access to compatible hardware or virtual environment
- Understanding of 802.1Q VLAN tagging

### Deployment Steps
1. **Hardware Setup** - Connect devices according to [topology diagram](docs/diagrams/network-topology.png)
2. **pfSense Configuration** - Follow [initial setup guide](docs/runbooks/initial-setup-guide.md)
3. **VLAN Configuration** - Configure switch per [port mapping](configs/switch/port-mapping.md)
4. **Firewall Rules** - Implement security policies from [firewall rules](configs/pfsense/firewall-rules.md)
5. **Service Deployment** - Deploy Pi-hole and other services on VLAN 40
6. **Validation** - Run [network tests](scripts/validation/network-tests.sh)

## 📚 Documentation

- **[Network Runbook](docs/runbooks/network-runbook-v1.4.md)** - Comprehensive operational guide
- **[Architecture Decisions](docs/architecture-decisions/)** - Design rationale and trade-offs
- **[Troubleshooting Guide](docs/runbooks/troubleshooting-guide.md)** - Common issues and solutions

## 🔄 Configuration Management

All configurations are version-controlled and documented:
- pfSense: Exported XML configs (sanitized)
- Switch: VLAN and port configurations
- Services: Container/VM configurations

### Backup Strategy
| Component | Frequency | Method | Retention |
|-----------|-----------|--------|-----------|
| pfSense | After every change | XML export | 30 days |
| Switch | After changes | Config export | Indefinite |
| Proxmox VMs | Nightly | Proxmox Backup Server | 14 days |
| Pi-hole | Weekly | Teleporter | 30 days |

## 🎓 Learning Outcomes

This project provided hands-on experience with:
- **Network Security:** Zone-based firewall design, principle of least privilege
- **VLAN Design:** 802.1Q tagging, trunk vs access ports, inter-VLAN routing
- **DNS Security:** DNS-level filtering, DoH/DoT, resolver configuration
- **Virtualization:** VLAN-aware networking, GPU passthrough, resource allocation
- **Infrastructure as Code:** Configuration documentation, version control, reproducibility

## 📈 Future Enhancements

- [ ] Cloudflare Zero Trust Tunnel implementation
- [ ] SIEM integration (Wazuh)
- [ ] Automated configuration drift detection
- [ ] Network performance monitoring (Grafana/InfluxDB)
- [ ] IDS/IPS with Snort/Suricata

## 🤝 Contributing

This is a personal learning project, but suggestions and feedback are welcome! Feel free to:
- Open an issue for questions or discussions
- Submit a PR for documentation improvements
- Share your own homelab experiences

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

These configurations are provided as educational examples. Always:
- Review and understand configurations before applying them
- Adapt security policies to your specific threat model
- Test changes in a non-production environment first
- Follow security best practices for your use case

## 📧 Contact

Questions? Feel free to reach out or open an issue!

---

**Project Status:** Active Development  
**Last Updated:** December 2024  
**Documentation Version:** v1.4
