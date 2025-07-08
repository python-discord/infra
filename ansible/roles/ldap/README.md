# LDAP

This role prepares the environment for FreeIPA to be installed on our Rocky
Linux-based LDAP host.

Note that the actual installation process and subsequent setup steps from
`ipa-server-install` must unfortunately be performed manually, as the automation
of this process is not something that we have deemed critical to automate at
this stage.

## Automatic Updates

This role configures `dnf-automatic` on Rocky Linux hosts to automatically
install security updates. The configuration:

- Downloads and installs security updates automatically
- Uses the default systemd timer schedule (daily)
- Sends notifications to stdio (visible in systemd journal)
- Reduces the manual maintenance burden for security patches

The dnf-automatic service runs via systemd timer and can be monitored using:
```bash
systemctl status dnf-automatic.timer
journalctl -u dnf-automatic.service
```
