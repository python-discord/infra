Kubernetes tips
===============

Find top pods by CPU/memory
---------------------------

.. code:: bash

   $ kubectl top pods --all-namespaces --sort-by='memory'
   $ top pods --all-namespaces --sort-by='cpu'

Find top nodes by CPU/memory
----------------------------

.. code:: bash

   $ kubectl top nodes --sort-by='cpu'
   $ kubectl top nodes --sort-by='memory'

Kubernetes cheat sheet
----------------------

`Open Kubernetes cheat
sheet <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>`__

Lens IDE
--------

`OpenLens <https://github.com/MuhammedKalkan/OpenLens>`__
