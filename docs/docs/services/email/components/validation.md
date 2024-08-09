---
description: Email validation practices used by Python Discord
---
# Email Validation

We apply best practices to validate inbound email, this includes requiring all
inbound mail to adhere to the sending domain's SPF, DKIM and DMARC policies.

## Services

### SPF

We use SPF to validate the sending domain of inbound mail. SPF is a DNS record
that specifies which mail servers are allowed to send mail on behalf of a
domain.

To achieve this validation, we use the
[postfix-policyd-spf-python](https://manpages.debian.org/testing/postfix-policyd-spf-python/policyd-spf.1.en.html)
package to validate the SPF record of inbound mail.

This Postfix plugin sits in the relay chain of Postfix and checks the SPF record
of the sending domain. If the SPF record is valid, the mail is passed on to the
next stage of delivery. If the SPF record is invalid, the mail is rejected.

```ini
smtpd_relay_restrictions =
                         permit_mynetworks,
                         permit_sasl_authenticated,
                         reject_unauth_destination,
                         reject_unauth_pipelining,
                         check_policy_service unix:private/policyd-spf,
```

*[SPF]: Sender Policy Framework

### DKIM

We use DKIM to validate the authenticity of the sending domain of inbound mail.
DKIM is a DNS record that contains a public key used to sign outbound mail.

To achieve this validation, we use the [OpenDKIM](http://www.opendkim.org/)
package to validate the DKIM signature of inbound mail.

On receipt of an inbound mail, Postfix passes the mail to OpenDKIM for
validation. If the DKIM signature is valid, the mail is passed on to the next
stage of delivery. If the DKIM signature is invalid, the mail is rejected.

*[DKIM]: DomainKeys Identified Mail

### DMARC

Tying the two previous methods together, we use DMARC to specify how SPF and
DKIM should be handled for a domain.

DMARC is a DNS record that specifies how mail servers should handle mail that
fails SPF and DKIM validation. DMARC can specify that mail should be rejected,
quarantined or accepted if it fails validation.

To achieve this validation, we use the
[OpenDMARC](https://github.com/trusteddomainproject/OpenDMARC) package to
validate the DMARC record of inbound mail.

We apply the following policies depending on the DMARC enforcement level:

- `none`: No action is taken, mail is delivered as normal
- `quarantine`: Mail is placed in the Postfix hold queue for manual review
- `reject`: Mail is rejected outright

See [this section](./postfix.md#managing-the-mail-queues) for more information
on managing the mail queues.

*[DMARC]: Domain-based Message Authentication, Reporting and Conformance

## DKIM & DMARC

DKIM and DMARC are configured in Postfix as milters. This means that Postfix
passes the mail to the milter for validation before continuing with the delivery
process.

The milters listen on a local network port and Postfix is configured to pass
mail to the milter for validation.

```ini
smtpd_milters = inet:localhost:8891,inet:localhost:8893
non_smtpd_milters = $smtpd_milters
milter_default_action = reject # (1)!
milter_protocol = 6
```

1. This line instructs Postfix to halt processing commands from a session as
   soon as a milter fails.!

*[milter]: Mail Filter
