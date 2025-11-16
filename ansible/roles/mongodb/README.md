# mongodb

This role deploys MongoDB using podman quadlets.

The container starts as root, but drops privileges after startup.


## Troubleshooting

- **MongoDB refuses connections**

  Verify that:

  1. Your outbound IP is within the whitelisted LKE ranges in `/etc/nftables` -
     the `nftables` Ansible role may be re-run to fetch them freshly

  2. Your outbound IP is not banned by `fail2ban`, see `fail2ban-client banned`

  3. You are using a sane piece of software that does not randomly appear to not
     bind on ports properly:

     > I encountered the same problem for an half an hour or so but it was not
     > an issue after that. I changed nothing in my code or my firewall
     > settings. Just waited a bit and the program worked as usual. So I think
     > this may be something that is wrong with the Mongodb servers or it may be
     > due to a slow network connection. Maybe check the uri and just waiting
     > for a while. It worked for me.

     When in doubt, `sudo systemctl restart mongodb`
