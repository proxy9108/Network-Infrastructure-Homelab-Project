# ADR 001: VLAN Segmentation Strategy

## Status
Accepted

## Context
Need to isolate untrusted devices (guests, IoT) from trusted services while maintaining usability.

## Decision
Implement 4-VLAN architecture: Home (20), Guest (30), Internal (40), IoT (50)

## Consequences
**Positive:**
- Strong security boundaries
- Granular firewall control
- Clear network organization

**Negative:**
- Added complexity
- Requires managed switch
- More firewall rules to maintain

## Alternatives Considered
- Flat network with host-based firewalls (rejected: less secure)
- More VLANs (rejected: over-engineering for homelab scale)
