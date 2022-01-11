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
   - Linux: `source venv/bin/activate`
1. Update pip and builder deps: `python -m pip install --upgrade pip wheel setuptools`
1. Install project dependancies: `python -m pip install -r requirements.txt`
1. Install the pre-commit hook: `pre-commit install`
