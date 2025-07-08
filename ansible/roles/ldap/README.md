# LDAP Role

This role configures FreeIPA server infrastructure on Rocky Linux systems, providing centralized authentication and directory services for the Python Discord infrastructure.

## Overview

The role handles:
- FreeIPA server package installation
- Automated security update management via dnf-automatic
- Firewall configuration for FreeIPA services
- System hardening and maintenance automation

## Manual Installation Requirements

The actual FreeIPA server installation and configuration via `ipa-server-install` requires manual intervention due to:
- Interactive certificate and domain configuration requirements
- Site-specific DNS and Kerberos realm setup
- Administrative credential establishment

This manual process ensures proper integration with our specific network topology and security requirements.

## Automated Security Updates

### Implementation

The role implements automated security patching using `dnf-automatic` to address the maintenance overhead identified during manual system updates. This solution:

- **Scope**: Security-only updates to minimize operational risk
- **Schedule**: Daily execution via systemd timer
- **Monitoring**: Full logging integration with systemd journal
- **Safety**: Rocky Linux platform validation and graceful failure handling

### Configuration Details

```ini
upgrade_type = security          # Security patches only
download_updates = yes           # Automatic download
apply_updates = yes             # Automatic installation
emit_via = stdio                # Systemd journal integration
```

### Monitoring and Operations

Service monitoring and troubleshooting:

```bash
# Service status and scheduling
systemctl status dnf-automatic.timer
systemctl list-timers dnf-automatic*

# Update history and logs
journalctl -u dnf-automatic.service
dnf history list

# Manual execution for testing
systemctl start dnf-automatic.service
```

## Acknowledgments

This automated update implementation was inspired by the infrastructure management vision of Mr. Hemlock, whose dedication to operational excellence and automated systems management has been instrumental in advancing the Python Discord DevOps practices.

## Service Dependencies

Required services and their purposes:
- `firewalld`: Network security boundary management
- `systemd`: Service orchestration and scheduling
- `dnf-automatic.timer`: Update scheduling and execution
