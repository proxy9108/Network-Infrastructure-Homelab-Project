## Troubleshooting

### Common Issues and Solutions

**Issue: Device not getting IP address**

Symptoms:
- Device shows "No IP address" or 169.254.x.x (APIPA)
- Cannot access network

Solutions:
```
1. Check physical connection
   - Cable seated properly?
   - Link light on switch port?

2. Verify VLAN membership
   - Is port configured for correct VLAN?
   - Check PVID setting on access ports

3. Check DHCP server
   - Services > DHCP Server > [VLAN]
   - Is DHCP enabled?
   - Are there available IPs in pool?

4. Check firewall rules
   - Does VLAN have allow rule for DHCP?
   - Firewall > Rules > [VLAN]
```

**Issue: Can't access Internal services from Home VLAN**

Symptoms:
- Timeout when trying to SSH/HTTPS to 192.168.40.x

Solutions:
```
1. Verify firewall rules
   - Firewall > Rules > HOME
   - Is there Pass rule for destination INTERNAL_NET?
   - Check port is allowed (22, 443, etc.)

2. Check service is running
   - SSH to server directly (if possible)
   - Is service listening? netstat -ln | grep [port]

3. Verify switch trunk
   - Is switch port 7 (Proxmox) configured as trunk?
   - Are VLANs 20 and 40 tagged?

4. Check VM VLAN tag
   - In Proxmox, is VM tagged with VLAN 40?
```

**Issue: Guest devices can access Internal network**

Symptoms:
- Guest device (192.168.30.x) can ping/access 192.168.40.x

⚠️ **SECURITY CRITICAL**

Solutions:
```
1. Check Guest firewall rules
   - Firewall > Rules > GUEST
   - Rule 2 should be: Block any from GUEST_NET to RFC1918
   - Is rule enabled and above "allow any" rule?

2. Verify RFC1918 alias
   - Firewall > Aliases
   - Does RFC1918 include 192.168.0.0/16?

3. Check rule order
   - Block rules MUST be above allow rules
   - Drag to reorder if needed

4. Clear states
   - Diagnostics > States > Reset States
   - Forces re-evaluation of firewall rules
```

**Issue: DNS not resolving**

Symptoms:
- "Host not found" errors
- Can ping 8.8.8.8 but not google.com

Solutions:
```
1. Check DHCP DNS assignment
   - What DNS server is client receiving?
   - ipconfig /all (Windows) or cat /etc/resolv.conf (Linux)

2. Verify Pi-hole is running
   - Browse to http://192.168.40.2/admin
   - Is Pi-hole responding?

3. Check DNS firewall rules
   - Is DNS (port 53) allowed from client VLAN?

4. Test DNS manually
   - nslookup google.com 192.168.40.2
   - Does direct query work?
```

**Issue: No Internet access on VLAN**

Symptoms:
- Can ping gateway (192.168.x.1)
- Cannot ping 8.8.8.8

Solutions:
```
1. Check NAT outbound rules
   - Firewall > NAT > Outbound
   - Should be set to "Automatic" or have manual rules for each VLAN

2. Verify default gateway
   - Is gateway set correctly in DHCP?
   - Services > DHCP Server > [VLAN]

3. Check WAN connectivity
   - Status > Interfaces > WAN
   - Is WAN interface up with IP?

4. Check firewall rules
   - Does VLAN have "allow any to any" Internet rule?
```

**Issue: Switch ports not working**

Symptoms:
- Device connected but no link light
- No network access

Solutions:
```
1. Physical check
   - Try different cable
   - Try different switch port
   - Check device NIC

2. Verify port configuration
   - VLAN > Port Config
   - Is port member of intended VLAN?
   - Is port tagged/untagged correctly?

3. Check PVID
   - Access ports must have correct PVID
   - Example: Port 4 should have PVID 20 for Home

4. Speed/duplex issues
   - Try forcing 100Mbps full duplex
   - Some devices don't auto-negotiate well
Diagnostic Commands
pfSense Console (Option 8: Shell):
bash# Show interface status
ifconfig

# Show VLAN interfaces
ifconfig | grep vlan

# Show active states
pfctl -s state

# Show firewall rules
pfctl -sr

# Check routing table
netstat -rn

# Test connectivity from pfSense
ping -S 192.168.20.1 8.8.8.8  # Source from VLAN 20
Check ARP table:
basharp -an
# Should show devices on various VLANs
```

### Log Analysis

**Firewall logs:**
```
Status > System Logs > Firewall

Useful filters:
- Action: block (show blocked traffic)
- Interface: GUEST (show specific VLAN)
- Destination: 192.168.40.0/24 (show attempts to access Internal)
```

**System logs:**
```
Status > System Logs > System

Look for:
- DHCP lease assignments
- Interface state changes
- Configuration changes
```

### Factory Reset (Last Resort)

If configuration becomes corrupted:

**pfSense:**
```
1. Diagnostics > Factory Reset
2. Wait 5 minutes for reboot
3. Restart this guide from beginning
```

**Switch:**
```
1. Press reset button 10+ seconds
2. Re-configure VLANs from scratch
3. Restore from backup if available
```

---
