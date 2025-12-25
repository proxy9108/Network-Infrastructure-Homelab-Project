# Testing & Validation

**File:** `docs/runbooks/initial-setup-guide/9. Testing & Validation.md`

Comprehensive testing to verify security boundaries and proper network segmentation.

---

## Connectivity Tests

### Test 1: VLAN 20 (Home) Connectivity

**Purpose:** Verify Home VLAN has proper access to Internal services and Internet.

From device on Home VLAN (192.168.20.x):
```bash
# Test gateway
ping 192.168.20.1
# Should succeed ✅

# Test Internet
ping 8.8.8.8
# Should succeed ✅

# Test DNS
nslookup google.com
# Should resolve ✅

# Test Internal VLAN access
ping 192.168.40.1
# Should succeed ✅

# Test HTTPS to Internal (if service running)
curl -k https://192.168.40.10
# Should connect ✅
```

**Expected Results:**
- ✅ All tests should succeed
- ✅ Home VLAN has full access to Internal services
- ✅ Internet connectivity confirmed

---

### Test 2: VLAN 30 (Guest) Isolation

**Purpose:** Verify Guest VLAN is isolated from internal networks.

From device on Guest VLAN (192.168.30.x):
```bash
# Test Internet
ping 8.8.8.8
# Should succeed ✅

# Test DNS
nslookup google.com
# Should resolve ✅

# Attempt to access Home VLAN
ping 192.168.20.1
# Should FAIL ❌ (timeout or filtered)

# Attempt to access Internal VLAN
ping 192.168.40.1
# Should FAIL ❌ (blocked by firewall)

# Attempt to SSH to Internal
ssh user@192.168.40.10
# Should FAIL ❌ (connection refused or timeout)
```

**Expected Results:**
- ✅ Internet access works
- ✅ DNS resolution works
- ❌ **Cannot** access Home VLAN (192.168.20.x)
- ❌ **Cannot** access Internal VLAN (192.168.40.x)

> **Critical Security Check:** Guest devices have Internet only, no LAN access.

---

### Test 3: VLAN 40 (Internal) Security

**Purpose:** Verify Internal VLAN accepts only authorized connections.

From device on Internal VLAN (192.168.40.x):
```bash
# Test Internet access
ping 8.8.8.8
# Should succeed ✅ (for updates)
```

**Test FROM Home VLAN (192.168.20.x):**
```bash
# From Home device:
ssh user@192.168.40.10
# Should succeed ✅
```

**Test FROM Guest VLAN (192.168.30.x):**
```bash
# From Guest device:
ssh user@192.168.40.10
# Should FAIL ❌ (blocked)
```

**Expected Results:**
- ✅ Internal can reach Internet
- ✅ Home VLAN can connect to Internal
- ❌ Guest VLAN **cannot** connect to Internal

---

### Test 4: VLAN 50 (IoT) Isolation

**Purpose:** Verify IoT VLAN is isolated from all internal networks.

From device on IoT VLAN (192.168.50.x):
```bash
# Test Internet
ping 8.8.8.8
# Should succeed ✅

# Attempt Internal access
ping 192.168.40.1
# Should FAIL ❌

# Attempt Home access
ping 192.168.20.1
# Should FAIL ❌
```

**Expected Results:**
- ✅ Internet access works
- ❌ **Cannot** access Internal VLAN
- ❌ **Cannot** access Home VLAN

---

## DNS Testing

### Verify Pi-hole Integration

**Test DNS blocking:**
```bash
# From any VLAN
nslookup doubleclick.net
# Should show blocked/NXDOMAIN if Pi-hole blocking ✅

# Check DNS server in use
nslookup google.com
# Server line should show Pi-hole (192.168.40.2) ✅
```

**Expected Results:**
- ✅ Ad/tracking domains return NXDOMAIN or 0.0.0.0
- ✅ DNS queries show Pi-hole IP (192.168.40.2) as server
- ✅ Legitimate domains resolve correctly

---

## Firewall Log Review

### Check Security Policy Enforcement

Navigate to: **Status > System Logs > Firewall**

**Look for:**
- ✅ Allowed connections from Home → Internal
- ❌ Blocked attempts from Guest → RFC1918
- ❌ Blocked attempts from IoT → RFC1918

**Filter examples:**
```
Interface: GUEST
Action: block
```

Should show blocked RFC1918 attempts from Guest VLAN.
```
Interface: IOT
Action: block
```

Should show blocked attempts from IoT devices to access internal networks.

**What to Look For:**
- Blocked traffic from Guest/IoT to 192.168.0.0/16
- Allowed traffic from Home to Internal on ports 443, 22, 80, 11434
- No unexpected allowed traffic between isolation zones

---

## DHCP Lease Verification

### Confirm Proper IP Assignment

Navigate to: **Status > DHCP Leases**

Verify devices are getting IPs in correct ranges:

| VLAN | Expected Range | Purpose |
|------|----------------|---------|
| Home | 192.168.20.100-199 | Trusted devices |
| Guest | 192.168.30.100-199 | Visitor devices |
| Internal | 192.168.40.100-199 | Servers (or static .2-.99) |
| IoT | 192.168.50.100-199 | Smart devices |

**Verification Steps:**
1. Connect device to each VLAN
2. Check assigned IP in DHCP leases
3. Verify IP is in correct subnet
4. Confirm DNS server assignment (should be Pi-hole: 192.168.40.2)

---

## Performance Baseline

### Measure Network Throughput

**Test Internet Speed:**
```bash
# From Home device to Internet
speedtest-cli
# or visit fast.com

# Document baseline for future comparison
```

**Record baseline metrics:**
- Download speed: _____ Mbps
- Upload speed: _____ Mbps
- Latency/ping: _____ ms
- Date tested: _____

### Check System Resource Usage

Navigate to: **Status > Dashboard**

**Record baseline metrics:**
- CPU usage: Should be <20% idle
- Memory usage: Note current %
- Traffic graphs: Document normal patterns
- State table: Note number of active connections

**Recommended Values:**
- CPU idle: >80%
- Memory usage: <50% under normal load
- State table: <1000 states for typical homelab

---

## Validation Checklist

Use this checklist after initial setup or major changes:

**Network Connectivity:**
- [ ] Home VLAN can reach Internet
- [ ] Home VLAN can reach Internal services
- [ ] Guest VLAN has Internet only
- [ ] Guest VLAN **cannot** reach Home or Internal
- [ ] IoT VLAN has Internet only
- [ ] IoT VLAN **cannot** reach any internal networks
- [ ] Internal VLAN can reach Internet

**DNS Resolution:**
- [ ] All VLANs resolve DNS queries
- [ ] Pi-hole blocking ads/trackers
- [ ] DNS queries logged in Pi-hole

**DHCP Assignment:**
- [ ] Devices get correct IP ranges per VLAN
- [ ] Static mappings working (Pi-hole, servers)
- [ ] DNS server assigned as Pi-hole (192.168.40.2)

**Security Policies:**
- [ ] Firewall logs show blocked Guest→Internal attempts
- [ ] Firewall logs show blocked IoT→Internal attempts
- [ ] Home→Internal connections allowed on approved ports only
- [ ] No unexpected traffic between isolation zones

**Performance:**
- [ ] Internet speeds meet baseline expectations
- [ ] pfSense CPU/memory usage normal
- [ ] No packet loss between VLANs
- [ ] DNS response times <10ms

---

## Troubleshooting Failed Tests

**If Home VLAN cannot reach Internal:**
- Check firewall rules on HOME interface
- Verify VLAN 40 allows traffic from HOME_NET
- Check switch trunk configuration

**If Guest can reach Internal (Security Failure!):**
- Verify Guest firewall rule #2 blocks RFC1918
- Check rule order (block must be before allow)
- Clear firewall states: Diagnostics > States > Reset States

**If DNS not resolving:**
- Verify Pi-hole is running (http://192.168.40.2/admin)
- Check DHCP is assigning correct DNS server
- Test DNS directly: `nslookup google.com 192.168.40.2`

**If no Internet access:**
- Check WAN interface status
- Verify NAT outbound rules exist for all VLANs
- Test from pfSense directly: `ping -S 192.168.20.1 8.8.8.8`

---

## Next Steps After Validation

Once all tests pass:

1. **Document Results**
   - Save test results with timestamps
   - Screenshot firewall logs showing proper blocking
   - Record performance baseline metrics

2. **Backup Configuration**
   - System > Backup & Restore
   - Export pfSense config
   - Save switch configuration

3. **Deploy Services**
   - Install Pi-hole on VLAN 40
   - Deploy Proxmox VMs with VLAN tags
   - Configure Tailscale remote access

4. **Enable Monitoring**
   - Set up regular log reviews
   - Configure email alerts for critical events
   - Plan monthly validation tests

---

**Previous:** [8. Access Point Setup](8.%20Access%20Point%20Setup.md) | **Next:** [10. Troubleshooting](10.%20Troubleshooting.md)
