---
description: A brief overview of LogQL syntax for querying logs stored in Loki.
---

# Loki queries

## Find any logs containing "ERROR"

``` shell
{job=~"default/.+"} |= "ERROR"
```

## Find all logs from bot service

``` shell
{job="default/bot"}
```

The format is `namespace/object`

## Rate of logs from a service

``` shell
rate(({job="default/bot"} |= "error" != "timeout")[10s])
```
