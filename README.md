# Infra

This repository contains the infrastructure configuration for Python Discord, the file structure is shown below, with well known files omitted for brevity:

[//]: <> (This structure is generated using https://tree.nathanfriend.io/.)
```
.github/
└── workflows/                           # GitHub Actions Workflows for CI
ansible/
├── host_vars/                           # Host specific Ansible variables
├── inventory/                           # Ansible Inventory files
├── local_testing/                       # Vagrant configuration to test Ansible playbook locally using VMs
├── roles/                               # Directory containing all Ansible roles
├── .ansible-lint                        # Configuration for ansible lint
├── ansible.cfg                          # Ansible Configurartion file
└── playbook.yml                         # Root playbook pulling all roles together
docs/
└── meeting_notes/                          # Minutes for previous devops meetings
kubernetes/
├── cluster-wide-secrets/                # Kubernetes secrets shared by multiple pods across namespaces
├── namespaces/                          # Kubernetes manifests, separated by namespace
└── scripts/                             # Scripts used to lint manifests in CI
.pre-commit-config.yaml                  # pre-commit configuration
server_bootstrap.sh                      # A bash script used to init our bare metal servers
```

## Documentation

Infrastructure-related documentation ("the big picture"), can be found in [`docs/`](./docs/) (Once written).

Many folders have a `README.md` file within them, which have more detailed explanations on what
that folder, and the files within, is used for.


## Acknowlegments

This is the coolest project. How can it not be when we have Volcy, the machine.