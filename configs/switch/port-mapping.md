# TP-Link TL-SG108E - Port Mapping

Physical reference for switch port assignments and VLAN configuration.

## Port Assignment Table

**Print and attach to equipment rack**

| Port | Mode | PVID/Access VLAN | Tagged VLANs | Connected Device | Status | Notes |
|------|------|------------------|--------------|------------------|--------|-------|
| 1 | **Trunk** | 1 (untagged) | 20,30,40,50 | **TP-Link EAP225 AP** | Active | Primary wireless |
| 2 | **Trunk** | 1 | 20,30,40,50 | Available | Inactive | Spare trunk port |
| 3 | **Trunk** | 1 | 20,30,40,50 | Available | Inactive | Spare trunk port |
| 4 | **Access** | 20 | None | Home wired device | Active | Home desktop |
| 5 | **Access** | 20 | None | Available | Inactive | Home expansion |
| 6 | **Access** | 40 | None | Available | Inactive | Internal expansion |
| 7 | **Trunk** | 1 | 20,30,40,50 | **Proxmox Host** | Active | VM infrastructure |
| 8 | **Access** | 40 | None | **Pi-hole** (192.168.40.2) | Active | DNS filtering |

## VLAN Configuration

### Global Settings
```
802.1Q VLAN: Enabled
VLAN IDs: 20, 30, 40, 50
Management VLAN: 20 (recommended) or 1 (default)
```

### VLAN Membership Table

| VLAN ID | Name | Tagged Ports | Untagged Ports | Purpose |
|---------|------|--------------|----------------|---------|
| 20 | Home | 1, 2, 3, 7 | 4, 5 | Trusted devices |
| 30 | Guest | 1, 2, 3, 7 | - | Guest WiFi |
| 40 | Internal | 1, 2, 3, 7 | 6, 8 | Services |
| 50 | IoT | 1, 2, 3, 7 | - | Smart devices |

### PVID (Port VLAN ID) Assignments
- **Trunk ports (1-3, 7):** PVID 1 (management, untagged native)
- **Home access (4-5):** PVID 20
- **Internal access (6, 8):** PVID 40

## Cable Management

**Recommended labeling:**
```
Port 1 → "AP-TRUNK-VLAN20.30.40.50"
Port 4 → "HOME-ACCESS-VLAN20"
Port 7 → "PROXMOX-TRUNK-ALL"
Port 8 → "PIHOLE-INTERNAL-VLAN40"
```

## Access Point Configuration

**Physical Connection:** Switch Port 1 (trunk)

**SSID → VLAN Mapping:**
| SSID | VLAN | Security | Broadcast | Purpose |
|------|------|----------|-----------|---------|
| Home_WiFi | 20 | WPA3/WPA2 | Yes | Primary trusted wireless |
| Guest_WiFi | 30 | WPA2 | Yes | Visitor access |
| IoT_WiFi | 50 | WPA2 | No | Smart home devices |

**Security Notes:**
- VLAN 40 (Internal) is **never broadcast on WiFi** - wired access only
- WPA3 preferred where supported for Home SSID
- Guest SSID uses client isolation

## Proxmox VLAN Configuration

**Physical Connection:** Switch Port 7 (trunk with all VLANs tagged)

**Bridge Configuration:**
```bash
# /etc/network/interfaces (Proxmox host)
auto vmbr0
iface vmbr0 inet manual
    bridge-ports enp0s31f6
    bridge-stp off
    bridge-fd 0
    bridge-vlan-aware yes
    bridge-vids 20 30 40 50
```

**VM VLAN Assignment:**
- Add VLAN tag in VM network device settings
- Example: Production VM → VLAN 40, Test VM → VLAN 20

## Troubleshooting

### Common Issues

**Device not getting IP:**
1. Check port mode (access vs trunk)
2. Verify PVID matches intended VLAN
3. Confirm VLAN exists in switch config
4. Check DHCP server on pfSense for that VLAN

**Inter-VLAN communication failing:**
1. Verify trunk ports have all required VLANs tagged
2. Check pfSense firewall rules
3. Confirm correct VLAN tags on both ends

**Wireless clients on wrong VLAN:**
1. Check AP's SSID → VLAN mapping
2. Verify Port 1 is trunk with correct tagged VLANs
3. Confirm AP is receiving tagged traffic

### Validation Commands

**From pfSense console:**
```bash
# Show VLAN interfaces
ifconfig | grep vlan

# Show DHCP leases per VLAN
cat /var/dhcpd/var/db/dhcpd.leases | grep "192.168"
```

**From switch web UI:**
- Navigate to VLAN → 802.1Q VLAN Configuration
- Verify port membership for each VLAN
- Check PVID settings match table above

## Change Log

**2024-12-25:**
- Initial documentation
- Aligned with Network Runbook v1.4
- Updated IoT from VLAN 60 to VLAN 50

---

**Configuration Export:** Export switch config after any changes via web UI (System Tools → Backup & Restore)
