# Kubernetes
Configuration and documentation for Python Discord's Kubernetes setup!

## Secrets
We use [git-crypt](https://www.agwa.name/projects/git-crypt/) ([Github](https://github.com/AGWA/git-crypt))to secure secrets. Using this means we can commit secrets to change control, without the secrets being leaked.

The [.gitattributes](.gitattributes) is used to determine which files to encrypt. See [git-crypt](https://www.agwa.name/projects/git-crypt/) documentation for more information.

To work with our secrets, you must have your GPG key's [validity attested](https://en.wikipedia.org/wiki/Keysigning) **and** added to the repo by a member of the devops team. Once that is done, you can use git-crypt as documented.

### git-crypt tl;dr
- Get/build a git-crypt binary from [GitHub](https://github.com/AGWA/git-crypt) or your favourite package manager
- Rename the binary to `git-crypt`
- Add binary to your PATH
- Run `git-crypt unlock` from this project's root directory.
See [git-crypt](https://www.agwa.name/projects/git-crypt/) documentation for more information.
