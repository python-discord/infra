# Role "pydis-mtls"

This role adds a copy of the Python Discord Root CA used for mutual TLS
authentication to a specified location on all hosts.

Services that need mutual TLS support should validate any incoming request
against this client certificate, the default provided with this role will always
be a subdomain of `tls.pydis.wtf` and the CN can be used for further
authorization validation.

## Variables

`pydis_mtls_certificate`: The CA Certificate contents to be copied to the host.
The default should be fine here and is the current production CA.

`pydis_mtls_location`: The location to copy the CA file to, defaults to
`/opt/pydis/ca.pem`.
