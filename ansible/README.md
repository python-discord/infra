# Ansible

This folder contains Ansible roles which are used to configure out bare metal servers.

## Local Environment Setup

If you are on Windows, you need to install WSL and run Ansible in there, as
[Ansible cannot run on Windows hosts
natively](https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows).
Debian Stable is recommended, but any Linux distribution should work.

From the project root directory:

1. Install the pre-commit hook: `pre-commit install`
1. Install UV: `curl -LsSf https://astral.sh/uv/install.sh | sh`
1. Install dependencies: `uv sync`
1. Head to the `ansible` directory: `cd ansible`
1. Install Ansible dependencies: `uv run ansible-galaxy install -r roles/requirements.yml`
1. Create a `vault_passwords` file and write the vault password to it
1. Configure the Ansible Vault git diff driver using `git config --global
   diff.ansible-vault.textconv "ansible-vault view"` and `git config diff.ansible-vault.cachetextconv false`

## Testing on Virtual machines

To setup a local environment using VMs for testing, [see the `local_testing`
directory](./local_testing/README.md).
