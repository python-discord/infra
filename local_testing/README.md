# Testing Locally

### Requirements

- [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Get Started

```shell
vagrant up                  # This will take a while
vagrant ssh                 # Get a shell, password=vagrant

# inside control VM
/vagrant/scripts/push-keys  # Push the control VM's ssh key to all nodes

# run ansible
ansible-playbook playbook.yml --inventory local_testing/hosts.yaml --user vagrant

```

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

### There was an error when attempting to rsync a synced folder.

```shell
vagrant plugin install vagrant-vbguest
```


### Kernel module is not loaded
```shell
sudo modprobe vbox{drv,netadp,netflt}
```
