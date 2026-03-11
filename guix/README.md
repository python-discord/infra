# DevOps Area 51

> This directory is a declarative deployment... and part of a system of
> declarative deployments... pay attention to it!

Here we test out declarative deployments using Guix on Turing. It serves mainly
as a playground for ideas.

## Deploying

**Prerequisites**

- Relevant SSH key (see `./ssh-keys/`) in your SSH agent
- Guix packaging ACL key deployed on turing
  - This is usually at `/etc/guix/signing-key`. If not, run `guix archive
    --generate-key` as root.
  - This is needed for the remote Guix instance to accept packages we build
    locally.

**Testing**

```sh
# Note that you presently need to run this as root, see
# https://codeberg.org/guix/guix/issues/4788
sudo $(guix system container --network machines/turing.scm)
# This uses your local host network. Use the `guix system container exec`
# command that prints to get a shell into the container. You can also use
# `guix system vm` or `guix system image` for a OCI-compatible image.
```

**Deploying**

```sh
# Optional, but recommended
# guix pull
guix deploy deployment.scm
```
