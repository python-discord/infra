# Role "nginx-cloudflare-mtls"

Installs the certificate required for performing mutual TLS authentication
between NGINX and Cloudflare.

To use mutual TLS in your NGINX virtual hosts, add this configuration snippet:

```nginx
ssl_client_certificate {{ nginx_cloudflare_mtls_certificate_path }};
ssl_verify_client on;
```


## Variables

See [role defaults](./defaults/main.yml) for an annotated overview.
