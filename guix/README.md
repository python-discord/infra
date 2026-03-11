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
- `sops-guix` configured as a channel. For this, add:

  ```scheme
  (cons* (channel
        (name 'sops-guix)
        (url "https://github.com/fishinthecalculator/sops-guix.git")
        (branch "main")
        ;; Enable signature verification:
        (introduction
         (make-channel-introduction
          "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
          (openpgp-fingerprint
           "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))
       %default-channels)
  ```

  to your `~/.config/guix/channels.scm`. After adding it, run `guix pull`.
- [`sops`](https://github.com/getsops/sops) installed locally, along with
  [`age`](https://github.com/FiloSottile/age).


**Host prerequisites**

One-time setup for Turing:

- `sudo age-keygen -o /root/pydis.txt`

Note down the public key and add it to `.sops.yaml`.

**Testing**

It is recommended to test building the image locally first to catch errors.

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
