# Infra

This repository contains the infrastructure configuration for Python Discord, the file structure is as follows:

```yaml
playbook.yml                         # Root playbook pulling all roles together
inventory.yaml                       # Ansible Inventory file
ansible.cfg                          # Ansible Configurartion file
roles/                               # Directory containing all Ansible roles
.github/
  workflows/                        # GitHub Actions Workflows for CI
requirements.txt                     # Python requirements
```

## Local Environment Setup
1. Create a virtual environment: `python -m venv venv`
1. Activate the virtual environment
   - Windows: `.\venv\Scripts\activate`
    - Note: [Ansible cannot run on Windows hosts natively](https://docs.ansible.com/ansible/latest/user_guide/windows_faq.html#can-ansible-run-on-windows)
   - Linux: `source venv/bin/activate`
1. Update pip and builder deps: `python -m pip install --upgrade pip wheel setuptools`
1. Install project dependancies: `python -m pip install -r requirements.txt`
1. Install the pre-commit hook: `pre-commit install`
1. Create a `vault_passwords` file and write the vault password to it


## Documentation

Infrastructure-related documentation ("the big picture"), once a sufficient
level of infrastructure is established, can be found in [`docs/`](./docs/).

Documentation for our Ansible roles can be found in the `README.md` file of
each role, and role defaults (at `roles/myrole/defaults/main.yml`) contain a
commented view on which variables are configurable for the given role.
