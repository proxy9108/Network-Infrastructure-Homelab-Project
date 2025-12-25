## Firewall Rules Configuration

Create security policies for each VLAN.

### Create Firewall Aliases First

Navigate to: **Firewall > Aliases**

**Network Aliases:**

Click **+ Add**

**RFC1918 Alias:**
```
Name: RFC1918
Description: Private Address Space
Type: Network(s)

Networks:
  10.0.0.0/8
  172.16.0.0/12
  192.168.0.0/16
```
Click **Save**

**HOME_NET Alias:**
```
Name: HOME_NET
Type: Network(s)
Networks: 192.168.20.0/24
```
Click **Save**

**GUEST_NET Alias:**
```
Name: GUEST_NET
Type: Network(s)
Networks: 192.168.30.0/24
```
Click **Save**

**INTERNAL_NET Alias:**
```
Name: INTERNAL_NET
Type: Network(s)
Networks: 192.168.40.0/24
```
Click **Save**

**IOT_NET Alias:**
```
Name: IOT_NET
Type: Network(s)
Networks: 192.168.50.0/24
```
Click **Save**

Click **Apply Changes**

**Port Aliases (Optional but Recommended):**
```
NEXTCLOUD_TCP: 443
OLLAMA_TCP: 11434
SSH_TCP: 22
HTTP_TCP: 80
DNS: 53
```

### VLAN 20 - HOME Firewall Rules

Navigate to: **Firewall > Rules > HOME**

**Delete default "allow all" rule if present**

**Rule 1: Allow DNS**
```
Action: Pass
Interface: HOME
Address Family: IPv4
Protocol: TCP/UDP

Source: HOME_NET
Destination: Single host or alias
Destination Address: 192.168.40.2 (or alias: This Firewall)
Destination Port: 53 (DNS)

Description: Allow DNS to Pi-hole
```
Click **Save**

**Rule 2: Allow HTTPS to Internal**
```
Action: Pass
Protocol: TCP

Source: HOME_NET
Destination: INTERNAL_NET
Destination Port: 443 (HTTPS)

Description: Allow HTTPS to Internal services (Nextcloud, etc.)

Advanced Options:
  Log: ☑ Log packets that are handled by this rule
```
Click **Save**

**Rule 3: Allow Ollama API**
```
Action: Pass
Protocol: TCP

Source: HOME_NET
Destination: INTERNAL_NET
Destination Port: 11434

Description: Allow Ollama API access
Log: ☑ Checked
```
Click **Save**

**Rule 4: Allow SSH to Internal**
```
Action: Pass
Protocol: TCP

Source: HOME_NET
Destination: INTERNAL_NET
Destination Port: 22 (SSH)

Description: Allow SSH to Internal servers
Log: ☑ Checked
```
Click **Save**

**Rule 5: Allow HTTP (optional - for admin pages)**
```
Action: Pass
Protocol: TCP

Source: HOME_NET
Destination: INTERNAL_NET
Destination Port: 80 (HTTP)

Description: Allow HTTP admin access
```
Click **Save**

**Rule 6: Allow Internet Access**
```
Action: Pass
Protocol: any

Source: HOME_NET
Destination: any

Description: Allow all Internet access
```
Click **Save**

Click **Apply Changes**

### VLAN 30 - GUEST Firewall Rules

Navigate to: **Firewall > Rules > GUEST**

**Rule 1: Allow DNS Only**
```
Action: Pass
Protocol: TCP/UDP

Source: GUEST_NET
Destination: Single host or alias
Destination Address: This Firewall (or 192.168.40.2)
Destination Port: 53

Description: Allow DNS only (enforces DNS filtering)
```
Click **Save**

**Rule 2: Block RFC1918 (All Private Networks)**
```
Action: Block
Protocol: any

Source: GUEST_NET
Destination: RFC1918 (alias)

Description: Block access to all private networks

Advanced:
  Log: ☑ Log packets blocked by this rule
```
Click **Save**

**Rule 3: Allow Internet**
```
Action: Pass
Protocol: any

Source: GUEST_NET
Destination: any

Description: Allow Internet access only
```
Click **Save**

Click **Apply Changes**

### VLAN 40 - INTERNAL Firewall Rules

Navigate to: **Firewall > Rules > INTERNAL**

**Rule 1: Allow from HOME to Internal Services**
```
Action: Pass
Protocol: TCP

Source: HOME_NET
Destination: INTERNAL_NET
Destination Port: 443, 11434, 22, 80 (multi-port)

Description: Allow Home VLAN access to Internal services
Log: ☑ Checked
```
Click **Save**

**Rule 2: Block Other RFC1918**
```
Action: Block
Protocol: any

Source: RFC1918
Destination: INTERNAL_NET

Description: Block other LANs from accessing Internal

Exceptions (above this rule):
  - HOME_NET already allowed
  - TAILSCALE_NET (add when configured)
```
Click **Save**

**Rule 3: Allow Internet Egress**
```
Action: Pass
Protocol: any

Source: INTERNAL_NET
Destination: any

Description: Allow Internal servers to reach Internet (updates, etc.)
```
Click **Save**

Click **Apply Changes**

### VLAN 50 - IOT Firewall Rules

Navigate to: **Firewall > Rules > IOT**

**Rule 1: Allow DNS Only**
```
Action: Pass
Protocol: TCP/UDP

Source: IOT_NET
Destination: This Firewall (or 192.168.40.2)
Destination Port: 53

Description: Allow DNS only
```
Click **Save**

**Rule 2: Block RFC1918**
```
Action: Block
Protocol: any

Source: IOT_NET
Destination: RFC1918

Description: Block all private network access
Log: ☑ Checked
```
Click **Save**

**Rule 3: Allow Internet**
```
Action: Pass
Protocol: any

Source: IOT_NET
Destination: any

Description: Allow Internet only
```
Click **Save**

Click **Apply Changes**

### Verify Firewall Rules

Navigate to: **Firewall > Rules**

Check each interface tab:
- [ ] HOME: 6 rules (DNS, Internal access × 4, Internet)
- [ ] GUEST: 3 rules (DNS, Block RFC1918, Internet)
- [ ] INTERNAL: 3 rules (Allow from Home, Block others, Internet)
- [ ] IOT: 3 rules (DNS, Block RFC1918, Internet)

---
