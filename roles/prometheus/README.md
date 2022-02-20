# Role "prometheus"

Installs and configured Prometheus on target servers.


## Variables

- `prometheus_cmdline_options` configures arguments to be added
  to the prometheus command line, and changing it will result in
  a restart.

- `prometheus_configuration` is the prometheus configuration, serialized to
  YAML by Ansible. If unset, the default Prometheus configuration is used.
