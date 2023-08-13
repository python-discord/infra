---
layout: default
title: Loki
---

# Loki queries

## Find any logs containing "ERROR"

```sql
{job=~"default/.+"} |= "ERROR"
```

## Find all logs from bot service

```sql
{job="default/bot"}
```

The format is `namespace/object`

## Rate of logs from a service

```sql
rate(({job="default/bot"} |= "error" != "timeout")[10s])
```
