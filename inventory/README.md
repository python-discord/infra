# Inventory
The main inventory for the pydis cluster, including configuration for kubespray.

## Content
- `group_vars`: Configuration variables for kubespray in various contexts.
This directory is not covered by ansible-lint, and should generally not be used to add new configuration.
Instead, that should be placed appropriately within the project as normal.
- `patches`
- `hosts.yaml`: The main hosts file for our infrastructure.

## Deployment
To deploy the kuberspray roles on our infrastructure, run the following commands in the root directory.

### Environment
Run the following commands, then enter your sudo password in the file that opens:

```shell
python3.10 -m venv venv
source venv/bin/activate
pip install -r kubespray/requirements-2.12.txt
export ANSIBLE_CONFIG=ansible.cfg
```

### Deployment
Enter your username into the command below, and run (this will take a while, so go grab a drink):

```
ansible-playbook kubespray/cluster.yml -v -u <user>
```

One useful argument for the command above is `--become-password-file`
which should point to a file with your sudo password for seamless execution.

Additionally, you may find it helpful to pre-configure all hosts in known_hosts
to prevent the prompt from timing out during execution. This can be achieved by SSHing
into the machines beforehand, or running an ad-hoc command and confirming all hosts.
