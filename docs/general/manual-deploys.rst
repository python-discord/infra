Manual Deployments
==================

When the DevOps team are not available, Administrators and Core
Developers can redeploy our critical services, such as Bot, Site and
ModMail.

This is handled through workflow dispatches on this repository. To get
started, head to the
`Actions <https://github.com/python-discord/kubernetes/actions>`__ tab
of this repository and select ``Manual Redeploy`` in the sidebar,
alternatively navigate
`here <https://github.com/python-discord/kubernetes/actions/workflows/manual_redeploy.yml>`__.

.. image:: https://user-images.githubusercontent.com/20439493/116442084-00d5f400-a84a-11eb-8e8a-e9e6bcc327dd.png

Click ``Run workflow`` on the right hand side and enter the service name
that needs redeploying, keep the branch as ``main``:

.. image:: https://user-images.githubusercontent.com/20439493/116442202-22cf7680-a84a-11eb-8cce-a3e715a1bf68.png

Click ``Run`` and refresh the page, you’ll see a new in progress Action
which you can track. Once the deployment completes notifications will be
sent to the ``#dev-ops`` channel on Discord.

If you encounter errors with this please copy the Action run link to
Discord so the DevOps team can investigate when available.
