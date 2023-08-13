# Snekbox-forms

This folder contains manifests for a Snekbox service specific to the forms project. This instance has no 3rd party libs installed, unlike regular snekbox, so submissions via forms can only use the stdlib.

The deployment manifest for this service is based on in manifest found inside the snekbox repository at [python-discord/snekbox](https://github.com/python-discord/snekbox), modified only by removing the volume mount, and 3rd party dep installation script.
