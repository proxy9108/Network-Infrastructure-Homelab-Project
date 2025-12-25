## VLAN Creation

Now we'll transform the flat network into segmented VLANs.

### Understanding the Architecture
```
Physical: Single NIC → Switch → Devices
Logical: VLAN 20 (Home)
         VLAN 30 (Guest)
         VLAN 40 (Internal)
         VLAN 50 (IoT)
```

### Step 1: Create VLAN Interfaces

Navigate to: **Interfaces > Assignments > VLANs**

**Create VLAN 20 (Home):**
```
Parent Interface: mvneta0 (or your LAN interface)
VLAN Tag: 20
VLAN Priority: (leave blank)
Description: HOME
```
Click **Save**

**Create VLAN 30 (Guest):**
```
Parent Interface: mvneta0
VLAN Tag: 30
Description: GUEST
```
Click **Save**

**Create VLAN 40 (Internal):**
```
Parent Interface: mvneta0
VLAN Tag: 40
Description: INTERNAL
```
Click **Save**

**Create VLAN 50 (IoT):**
```
Parent Interface: mvneta0
VLAN Tag: 50
Description: IOT
```
Click **Save**

**Verify VLAN Creation:**

You should see:
```
VLAN 20 on mvneta0 - HOME
VLAN 30 on mvneta0 - GUEST
VLAN 40 on mvneta0 - INTERNAL
VLAN 50 on mvneta0 - IOT
```

### Step 2: Assign VLAN Interfaces

Navigate to: **Interfaces > Assignments**

**Assign VLANs to Interfaces:**

Click **+ Add** for each available VLAN:
```
OPT1 → VLAN 20 (mvneta0 - HOME)
OPT2 → VLAN 30 (mvneta0 - GUEST)
OPT3 → VLAN 40 (mvneta0 - INTERNAL)
OPT4 → VLAN 50 (mvneta0 - IOT)
```

Click **Save**

Your interface assignments should now show:
```
WAN → mvneta0 (WAN)
LAN → mvneta1 (or bridge)
OPT1 → VLAN 20
OPT2 → VLAN 30
OPT3 → VLAN 40
OPT4 → VLAN 50
```

### Step 3: Configure Each VLAN Interface

**Configure VLAN 20 (HOME):**

1. Navigate to: **Interfaces > OPT1**
2. Configure:
```
☑ Enable: Checked
Description: HOME
IPv4 Configuration Type: Static IPv4
IPv6 Configuration Type: None

IPv4 Address: 192.168.20.1 / 24
```
3. Click **Save**
4. Click **Apply Changes**

**Configure VLAN 30 (GUEST):**

1. Navigate to: **Interfaces > OPT2**
2. Configure:
```
☑ Enable: Checked
Description: GUEST
IPv4 Configuration Type: Static IPv4
IPv6 Configuration Type: None

IPv4 Address: 192.168.30.1 / 24
```
3. Click **Save**
4. Click **Apply Changes**

**Configure VLAN 40 (INTERNAL):**

1. Navigate to: **Interfaces > OPT3**
2. Configure:
```
☑ Enable: Checked
Description: INTERNAL
IPv4 Configuration Type: Static IPv4
IPv6 Configuration Type: None

IPv4 Address: 192.168.40.1 / 24
```
3. Click **Save**
4. Click **Apply Changes**

**Configure VLAN 50 (IOT):**

1. Navigate to: **Interfaces > OPT4**
2. Configure:
```
☑ Enable: Checked
Description: IOT
IPv4 Configuration Type: Static IPv4
IPv6 Configuration Type: None

IPv4 Address: 192.168.50.1 / 24
```
3. Click **Save**
4. Click **Apply Changes**

### Step 4: Verify Interface Status

Navigate to: **Status > Interfaces**

All VLANs should show:
```
HOME (OPT1) - Status: up - IPv4: 192.168.20.1/24
GUEST (OPT2) - Status: up - IPv4: 192.168.30.1/24
INTERNAL (OPT3) - Status: up - IPv4: 192.168.40.1/24
IOT (OPT4) - Status: up - IPv4: 192.168.50.1/24
```

---
