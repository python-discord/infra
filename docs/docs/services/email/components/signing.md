---
description: DKIM signing for Python Discord services
---
# Mail Signing

Outbound mail is signed using DKIM to validate the authenticity of the sending
domain. DKIM is a DNS record that contains a public key used to sign outbound
mail.

We use our [OpenDKIM
role](https://github.com/python-discord/infra/tree/main/ansible/roles/opendkim)
which allows us to use the same OpenDKIM instance to sign mail from multiple
domains.

On sending an outbound mail, Postfix passes the mail to OpenDKIM for signing.
OpenDKIM signs the mail with the private key and adds the DKIM signature to the
mail headers.

DKIM keys are stored in DNS as a TXT record, this is also configured in the
infra repository using our OctoDNS setup.
