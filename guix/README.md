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

**Deploying**

```sh
# Optional, but recommended
# guix pull
guix deploy turing.scm
```
