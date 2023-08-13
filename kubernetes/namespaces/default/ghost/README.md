# Ghost

This folder contains the deployment manifests for Ghost, the CMS we use for https://blog.pythondiscord.com/.

There should be no additional configuration required, there is a setup process on the domain when Ghost first boots, you can reach it by going to https://blog.pythondiscord.com/ghost/ immediately after starting the deployment.

To deploy this application run `kubectl apply -f ghost` from the root directory of this repository. This will create a deployment, service ingress and persistent volume.
