# Grafana Alloy

This role deploys an instance of Grafana Alloy with configuration that by
default:
- Exports the system journal to the configured Loki instance
- Exports other log files to the configured Loki instance, including:
  - `/var/log/auth.log`

It requires the addition of the Grafana package repository to allow Alloy to be
installed with `apt`. This is handled by the role.

## Configuration values

Required user configuration options:

- `alloy_loki_endpoint`: The Loki log push endpoint to stream logs into.

Defaulted configuration options:

- `alloy_grafana_signing_key`: Signing key URL to use for Grafana packages
  (default: `https://apt.grafana.com/gpg.key`)
- `alloy_grafana_signing_key_fingerprint`: Expected key fingerprint from above
  configuration key, used to prevent malicious tampering (default: most recent
  known fingerprint of above address)
- `alloy_grafana_repository`: Repository to configure and add to aptitude
  (default: `deb https://apt.grafana.com stable main`)
