---
description: How to get help when working with Python Discord infrastructure
---
# Getting Help

When working with Python Discord's infrastructure, you may encounter issues or need assistance. This guide outlines the various ways to get help and who to contact for different types of problems.

## :sos: Emergency Procedures

### Critical Infrastructure Issues

For **critical incidents** affecting production services:

1. **Immediate Response**: Post in the `#dev-oops` Discord channel with `@here` mention
2. **Assessment**: Briefly describe the issue and impact
3. **Escalation**: If no response within 15 minutes, contact DevOps team leads directly

### After-Hours Emergencies

For emergencies outside normal hours:

1. Contact the on-call DevOps team member (rotation schedule in `#dev-oops` pinned messages)
2. If unable to reach on-call person, escalate to DevOps team leads
3. Document the incident for post-mortem analysis

## :raising_hand: Getting Help by Problem Type

### Infrastructure Questions

**For questions about services, configurations, or deployments:**

- **Primary**: Ask in `#dev-oops` Discord channel
- **Secondary**: [Open a GitHub issue](https://github.com/python-discord/infra/issues/new) on the infra repository
- **Resources**: Check the [Knowledge base](https://docs.pydis.wtf/) first

### Service-Specific Issues

**For problems with specific services:**

| Service Type | Primary Contact | Resources |
|--------------|-----------------|-----------|
| Kubernetes Cluster | `#dev-oops` channel | [Common Queries](./common-queries/kubernetes.md) |
| PostgreSQL Database | `#dev-oops` channel | [PostgreSQL Queries](./common-queries/postgresql.md) |
| Email Services | `#dev-oops` channel | [Email Documentation](./services/email/index.md) |
| LDAP/Authentication | `#dev-oops` channel | [LDAP Documentation](./services/LDAP/index.md) |
| DNS Issues | `#dev-oops` channel | DNS configuration in infra repo |
| Monitoring/Alerting | `#dev-oops` channel | [Loki Queries](./common-queries/loki.md) |

### Access and Permissions

**For access issues or permission requests:**

1. Check the [Access Table](./onboarding/access-table.md) for current permissions
2. Request access in `#dev-oops` channel with:
   - What access you need
   - Why you need it
   - How long you need it (if temporary)

## :books: Self-Help Resources

Before asking for help, check these resources:

### Documentation Sections

- **[Runbooks](./runbooks/index.md)**: Step-by-step guides for common tasks
- **[Common Queries](./common-queries/index.md)**: Pre-built queries for troubleshooting
- **[Post-mortems](./post-mortems/index.md)**: Learn from past incidents
- **[Service Documentation](./services/index.md)**: Detailed service information

### Quick Troubleshooting

1. **Check service status**: Look at monitoring dashboards
2. **Review recent changes**: Check recent deployments or configuration changes
3. **Search past incidents**: Look through post-mortems for similar issues
4. **Verify access**: Ensure you have the necessary permissions

## :toolbox: Troubleshooting Workflows

### Service Down or Unresponsive

1. **Immediate**: Check if it's a known incident (`#dev-oops` announcements)
2. **Investigate**:
   - Check Kubernetes pod status
   - Review application logs
   - Verify dependencies (database, external services)
3. **Escalate**: If unable to resolve in 30 minutes, ask for help

### Performance Issues

1. **Gather data**: Collect metrics and logs showing the performance problem
2. **Check resources**: Review CPU, memory, and network usage
3. **Recent changes**: Identify any recent deployments or configuration changes
4. **Document**: Include specific metrics when asking for help

### Configuration Problems

1. **Verify syntax**: Check YAML/configuration file syntax
2. **Compare with working examples**: Look at similar working configurations
3. **Test in staging**: If available, test changes in non-production environment
4. **Rollback plan**: Have a rollback strategy before making changes

## :phone: Contact Information

### Discord Channels

- **`#dev-oops`**: Primary channel for all infrastructure discussions
- **`#admin-chat`**: For administrative and governance discussions

### GitHub

- **[Infra Repository Issues](https://github.com/python-discord/infra/issues)**: For bugs, feature requests, and documentation improvements

### When to Use Each Channel

| Type of Request | Discord `#dev-oops` | GitHub Issue |
|----------------|-------------------|--------------|
| Urgent issues | :white_check_mark: | |
| Quick questions | :white_check_mark: | |
| Bug reports | :white_check_mark: | :white_check_mark: |
| Feature requests | | :white_check_mark: |
| Documentation improvements | | :white_check_mark: |
| Complex discussions | :white_check_mark: | |

## :memo: When Asking for Help

### Information to Include

**Always provide:**

- **What you're trying to do**: Clear description of your goal
- **What you expected**: What should have happened
- **What actually happened**: What went wrong (include error messages)
- **Environment**: Which service/system is affected
- **Recent changes**: Any recent modifications that might be related

**For service issues, also include:**

- Timestamps of when the issue started
- Affected services or users
- Current impact level
- Steps already taken to troubleshoot

### Example Help Request

```
🚨 PostgreSQL Connection Issues

**Goal**: Deploy new bot update to production
**Expected**: Bot should connect to database normally
**Actual**: Getting connection timeout errors

**Environment**: Production bot deployment
**Started**: ~2:30 PM UTC
**Impact**: Bot is offline, affecting all Discord functionality

**Error**: `connection to server at "postgres.pydis.svc.cluster.local" (10.2.3.4), port 5432 failed: timeout expired`

**Already tried**:
- Checked pod logs (show connection attempts)
- Verified database pod is running
- No recent config changes

**Need help**: Investigating why connections are timing out
```

## :books: Learning Resources

### For New Team Members

1. Start with [Onboarding documentation](./onboarding/index.md)
2. Review [DevOps Rules](./onboarding/rules.md)
3. Explore [Available Tools](./onboarding/tools.md)
4. Shadow experienced team members during incidents

### Skill Development

- **Kubernetes**: Practice with local clusters, review runbooks
- **PostgreSQL**: Study common queries and maintenance procedures
- **Monitoring**: Learn Grafana, Prometheus, and Loki query languages
- **Infrastructure as Code**: Understand our Ansible and Kubernetes manifests

## :question: Frequently Asked Questions

### "I'm new to the team, where do I start?"

1. Read the [Onboarding guide](./onboarding/index.md)
2. Get required access from the [Access Table](./onboarding/access-table.md)
3. Join the `#dev-oops` Discord channel
4. Introduce yourself and ask for a team overview

### "I made a mistake, what should I do?"

1. **Don't panic**: Mistakes happen and are learning opportunities
2. **Assess impact**: Determine if it's affecting production services
3. **Communicate**: Post in `#dev-oops` immediately if there's any impact
4. **Document**: Help create a post-mortem to prevent future occurrences

### "I'm not sure if this is urgent, should I ask for help?"

**When in doubt, ask!** It's better to ask for help unnecessarily than to let a small issue become a major incident.

---

## Contributing to This Guide

Found something unclear or have suggestions for improvement?

- [Open an issue](https://github.com/python-discord/infra/issues/new) on the infra repository
- Suggest changes via pull request
- Bring it up in `#dev-oops` for discussion

Remember: Good documentation helps everyone work more effectively! :rocket:
