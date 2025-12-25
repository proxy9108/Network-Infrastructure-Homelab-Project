# pfSense Initial Configuration

**File:** `docs/runbooks/initial-setup-guide/3. pfSense Initial Configuration.md`

---

## Accessing pfSense Web Interface

### Step 1: Obtain IP Address

Your computer should automatically receive:
```
IP Address: 192.168.1.x (via DHCP)
Gateway: 192.168.1.1
DNS: 192.168.1.1
```

Verify connection:
```bash
# Windows
ipconfig

# macOS/Linux
ip addr show
# or
ifconfig
```

### Step 2: Open Web Interface

1. Open web browser
2. Navigate to: `https://192.168.1.1`
3. Accept self-signed certificate warning (expected on first boot)
4. Login with default credentials:
   - **Username:** `admin`
   - **Password:** `pfsense`

⚠️ **Security Note:** You MUST change the default password immediately.

---

## Setup Wizard

### Step 1: General Information

Click **Next** through welcome screen, then configure:
```
Hostname: pfsense (or your preference)
Domain: local.lan (or your domain)
Primary DNS: 1.1.1.1 (Cloudflare)
Secondary DNS: 1.0.0.1 (Cloudflare backup)

☑ Override DNS: Checked (important for client DNS control)
```

### Step 2: Time Server Information
```
Time Server Hostname: pool.ntp.org
Timezone: (Select your timezone)
```

### Step 3: Configure WAN Interface
```
☑ Block RFC1918 Private Networks: Unchecked (Starlink uses CGNAT)
☑ Block bogon networks: Checked
```

For most home connections:
```
IPv4 Configuration Type: DHCP
IPv6 Configuration Type: None (or DHCP6 if your ISP supports it)
```

### Step 4: Configure LAN Interface

⚠️ **IMPORTANT:** We'll change this later for VLAN architecture

For now, use:
```
LAN IP Address: 192.168.20.1
Subnet Mask: 24
```

> **Why 192.168.20.1?** We're using `.20.x` for VLAN 20 (Home) to maintain consistency.

### Step 5: Set Admin Password
```
Admin Password: [Strong password - use password manager]
Confirm Password: [Repeat password]
```

**Password Requirements:**
- Minimum 12 characters
- Mix of upper/lower case, numbers, symbols
- Store securely in password manager

### Step 6: Reload Configuration

Click **Reload** and wait 30-60 seconds for pfSense to apply changes.

---

## Post-Wizard Configuration

### Step 1: Reconnect to New IP

Your computer will need a new IP address:
```bash
# Windows
ipconfig /release
ipconfig /renew

# macOS/Linux
sudo dhclient -r
sudo dhclient
```

### Step 2: Access New Interface

Navigate to: `https://192.168.20.1`

Login with your new admin credentials.

### Step 3: Update pfSense (Important)
```
1. System > Update
2. Check for updates
3. Install if available
4. Wait for reboot (5-10 minutes)
5. Re-login after reboot
```

---

## Initial Security Hardening

### Disable SSH (unless needed)
```
System > Advanced > Admin Access
☐ Enable Secure Shell (unchecked)
```

### Configure Session Timeout
```
System > Advanced > Admin Access
Session Timeout: 30 (minutes)
```

### Enable HTTPS Only
```
System > Advanced > Admin Access
Protocol: HTTPS
☑ Disable HTTP_REFERER enforcement checks (unchecked for security)
```

---

**Previous:** [2. Hardware Assembly](2.%20Hardware%20Assembly.md) | **Next:** [4. VLAN Creation](4.%20VLAN%20Creation.md)
