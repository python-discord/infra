Loki queries
============

Find any logs containing “ERROR”
--------------------------------

.. code:: shell

   {job=~"default/.+"} |= "ERROR"

Find all logs from bot service
------------------------------

.. code:: shell

   {job="default/bot"}

The format is ``namespace/object``

Rate of logs from a service
---------------------------

.. code:: shell

   rate(({job="default/bot"} |= "error" != "timeout")[10s])
