# Testing Locally

This section contains the necessary steps in order to be able to setup virtual machines that mimic our netcup servers and be able to run the ansible roles/playbooks we have on them.

### Requirements

- [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)


### Getting started

1. Creating the virtual boxes

On your host machine, run the following:

```bash
cd ansible/local_testing
vagrant up
```

This will create all the virtual boxes on which we will run our ansible playbooks.

2. Push the control VM's ssh key to all nodes


```bash
vagrant ssh  # This will give you terminal access to the `control` VM, which we will use as the ansible control node.

cd /home/vagrant/infra
bash ./ansible/local_testing/scripts/push-keys
```

> If you're on windows, you might run into line ending issues when running the `push-keys` script.
> To fix it, run this **while still inside the ssh session*: `sed -i 's/\r$//' /home/vagrant/infra/ansible/local_testing/scripts/push-keys`


3. Run the ansible setup playbook

```bash
cd /home/vagrant/infra/ansible
ansible-playbook playbook.yml --inventory local_testing/hosts.yaml --user vagrant
```

> This will prompt you for the sudo password, whose value is `vagrant`.


### Virtual machine IPs

Below are the IPs of the VMs on the VirtualBox network
```yaml
vms:
- control: 192.168.56.1
- hopper: 192.168.56.2
- lovelace: 192.168.56.3
- neumann: 192.168.56.4
- richie: 192.168.56.5
- turing: 192.168.56.6
```


# Fixes/Notes


### Ansible cannot decrypt the files encrypted with ansible vault.

* The `ansible/roles/certbot/vars/main.yaml` and `ansible/roles/pydis-users/vars/main.yaml` files have been encrypted with ansible vault due to their sensitive content.

* If you lack access to the vault, you're going to have to either define your own variables or exclude the appropriate roles.

* If you do have access to the vault, make sure that your `vault_passwords` file has been synced to the vagrant control VM.


### There was an error when attempting to rsync a synced folder.

```shell
vagrant plugin install vagrant-vbguest
```

### Some files are not synced from the host machine to the control VM

Try forcing the sync by running this command `vagrant rsync-auto`

### Kernel module is not loaded
```shell
sudo modprobe vbox{drv,netadp,netflt}
```
