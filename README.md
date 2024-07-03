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
dns/
├── zones/                               # Zone configuration for each supported DNS Zone
└── production.yaml                      # Configuration for OctoDNS planning and deployment
docs/
└── meeting_notes/                       # Minutes for previous devops meetings
kubernetes/
├── cluster-wide-secrets/                # Kubernetes secrets shared by multiple pods across namespaces
├── namespaces/                          # Kubernetes manifests, separated by namespace
└── scripts/                             # Scripts used to lint manifests in CI
.pre-commit-config.yaml                  # pre-commit configuration
server_bootstrap.sh                      # A bash script used to init our bare metal servers
```

## Documentation

Infrastructure-related documentation ("the big picture"), can be found in [`docs/`](./docs/).

Many folders have a `README.md` file within them, which have more detailed explanations on what
that folder, and the files within, is used for.


## Commit verification

All commits on the `main` branch are signed by the DevOps team members, which
is verified via our [GitHub workflow to run `guix git
authenticate`](.github/workflows/authenticate.yml).

Due to the access to sensitive data we have, we need to ensure that we can
trust what we are running on both our computers and deploying into the cluster.
All DevOps team members are therefore strongly encouraged to incorporate this
setup into their local setup. Installing GNU Guix (`apt install guix`) and
running the following command will get you started:

```sh
guix git authenticate 31c3821ce936b4d70924f76431b0ce25235f76f0 8C05D0E98B7914EDEBDCC8CC8E8E09282F2E17AF
```

This will install `pre-push` and `pre-merge` hooks that authenticate the
repository anytime you run `git pull` or `git push`, ensuring only approved
commiters get their code on your machine.

If you are curious why we use this when GitHub already marks signed commits
with a checkmark, the reason is that GitHub's checkmark only states that a
commit was signed, but that on its own does not _authenticate_ whether that
commit is signed by a trusted key. More information can be found at
[Authenticate your Git
checkouts!](https://guix.gnu.org/en/blog/2024/authenticate-your-git-checkouts/).
