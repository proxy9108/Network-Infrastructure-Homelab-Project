# pfSense Firewall Rules

Complete firewall rule documentation for VLAN-segmented network.

## Design Philosophy

**Zero-Trust Approach:**
- Default deny on all interfaces
- Explicit allow rules for required traffic only
- Internal services accept connections only from authorized sources

**Rule Order Principles:**
1. Allow rules for essential services (DNS, DHCP)
2. Block rules for RFC1918 lateral movement
3. Allow rules for approved inter-VLAN access
4. Default allow for Internet egress

## VLAN 20 - Home (Trusted)

**Security Posture:** Trusted zone with controlled access to Internal services

| # | Action | Proto | Source | Destination | Port | Purpose | State |
|---|--------|-------|--------|-------------|------|---------|-------|
| 1 | Pass | TCP/UDP | HOME_NET | pfSense (this firewall) | 53 | DNS to pfSense | Active |
| 2 | Pass | TCP/UDP | HOME_NET | 192.168.40.2 | 53 | DNS to Pi-hole | Active |
| 3 | Pass | TCP | HOME_NET | INTERNAL_NET | 443 | HTTPS to Internal services | Active |
| 4 | Pass | TCP | HOME_NET | INTERNAL_NET | 11434 | Ollama API access | Active |
| 5 | Pass | TCP | HOME_NET | INTERNAL_NET | 22 | SSH to Internal servers | Active |
| 6 | Pass | TCP | HOME_NET | INTERNAL_NET | 80 | HTTP admin access | Active |
| 7 | Pass | any | HOME_NET | any | * | Internet access | Active |

**Logging:** Rules 3-6 log connections for security monitoring

---

## VLAN 30 - Guest (Internet-Only)

**Security Posture:** Untrusted zone with no LAN access

| # | Action | Proto | Source | Destination | Port | Purpose | State |
|---|--------|-------|--------|-------------|------|---------|-------|
| 1 | Pass | TCP/UDP | GUEST_NET | pfSense / 192.168.40.2 | 53 | DNS only | Active |
| 2 | Block | any | GUEST_NET | RFC1918 | * | Block all private networks | Active |
| 3 | Pass | any | GUEST_NET | any | * | Internet access | Active |

**Key Security Controls:**
- Rule #2 blocks access to all RFC1918 networks (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- DNS is enforced (guests cannot use alternative DNS servers)
- No path to Internal, Home, or IoT networks

---

## VLAN 40 - Internal (Restricted)

**Security Posture:** Maximum protection; accepts only from Home + Tailscale

| # | Action | Proto | Source | Destination | Port | Purpose | State |
|---|--------|-------|--------|-------------|------|---------|-------|
| 1 | Pass | TCP | HOME_NET | INTERNAL_NET | 443,11434,22,80 | Allow from Home VLAN | Active |
| 2 | Pass | TCP | TAILSCALE_NET | INTERNAL_NET | 443,11434,22,80 | Allow from Tailscale | Active |
| 3 | Block | any | RFC1918 | INTERNAL_NET | * | Block all other LANs | Active |
| 4 | Pass | any | INTERNAL_NET | any | * | Allow Internet egress | Active |

**Access Control Matrix:**

| Source | Allowed Ports | Services |
|--------|---------------|----------|
| Home VLAN | 443, 11434, 22, 80 | Nextcloud, Ollama, SSH, HTTP |
| Tailscale | 443, 11434, 22, 80 | Full remote access |
| Guest VLAN | ❌ Blocked | No access |
| IoT VLAN | ❌ Blocked | No access |

---

## VLAN 50 - IoT (Internet-Only)

**Security Posture:** Isolated zone with no LAN access

| # | Action | Proto | Source | Destination | Port | Purpose | State |
|---|--------|-------|--------|-------------|------|---------|-------|
| 1 | Pass | TCP/UDP | IOT_NET | pfSense / 192.168.40.2 | 53 | DNS only | Active |
| 2 | Block | any | IOT_NET | RFC1918 | * | Block all private networks | Active |
| 3 | Pass | any | IOT_NET | any | * | Internet access | Active |

**Exception Handling:**
If specific IoT devices need Internal access (e.g., cameras → NVR):
- Insert **above Rule #2**
- Use specific source IPs and destination ports only
- Document business justification

Example exception rule:
```
Pass | TCP | 192.168.50.10 (camera) | 192.168.40.15 (NVR) | 554 (RTSP)
```

---

## Firewall Aliases

**Network Aliases:**
```
RFC1918 = 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
HOME_NET = 192.168.20.0/24
GUEST_NET = 192.168.30.0/24
INTERNAL_NET = 192.168.40.0/24
IOT_NET = 192.168.50.0/24
TAILSCALE_NET = 100.64.0.0/10 (or specific IPs)
```

**Port Aliases:**
```
NEXTCLOUD_TCP = 443
OLLAMA_TCP = 11434
SSH_TCP = 22
HTTP_TCP = 80
DNS = 53
```

---

## Testing & Validation

After applying rules, test:

**VLAN 30 (Guest) Tests:**
```bash
# From Guest device
ping 192.168.20.1    # Should FAIL (blocked by Rule #2)
ping 192.168.40.2    # Should FAIL (blocked by Rule #2)
ping 8.8.8.8         # Should SUCCEED (Rule #3)
nslookup google.com  # Should SUCCEED via pfSense/Pi-hole
```

**VLAN 20 (Home) Tests:**
```bash
# From Home device
curl https://192.168.40.x:443  # Should SUCCEED (Rule #3)
ssh user@192.168.40.x          # Should SUCCEED (Rule #5)
```

**VLAN 40 (Internal) Access Tests:**
```bash
# From Guest or IoT device
curl https://192.168.40.x:443  # Should FAIL (blocked)

# From Tailscale
ssh user@192.168.40.x          # Should SUCCEED (Rule #2)
```

---

## Change Log

**2024-12:** Initial documentation aligned with v1.4 network runbook
- Removed VLAN 10 (Pentest) rules
- Updated IoT from VLAN 60 to VLAN 50
- Added Tailscale access controls

**Best Practice:** Test all rule changes in pfSense's rule staging environment before applying to production.
