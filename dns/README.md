# DNS Management

This folder manages DNS records across the zones we use. It uses [OctoDNS](https://github.com/octodns/octodns) with the Cloudfare provider to push and synchronize zone records with the YAML files in the `zones` folder.

## Usage

Edit the YAML files in `zones/` to add, update or delete records.

If you have a local OctoDNS tokens for Cloudflare, you can install the dependencies with `poetry install --only dns` in the root folder and then run `poetry run octodns-sync --config-file dns/production.yaml`.

**NOTE:** All commands have must run from the root directory of the repository, this is because in GitHub Actions the environment is the root folder.

## Deployment

If a PR includes DNS changes, a GitHub Actions workflow will comment all the amendments that will be made to the production setup in the PR comments. This comment will be updated for subsequent pushes to that branch.

Once a PR is merged to `main`, the planned deployments will be executed on the production Cloudflare account.

## Environment

| Environment Variable    | Description                                                                                      |
|-------------------------|--------------------------------------------------------------------------------------------------|
| `CLOUDFLARE_TOKEN`      | The Cloudflare token that (at least) has `Zone:Read` and `DNS:Read`, or if deploying `DNS:Write` |
| `CLOUDFLARE_ACCOUNT_ID` | The Account ID to scope updates to                                                               |
