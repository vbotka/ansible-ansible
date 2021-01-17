.. _ug_task_task2_ex2:

Example 2: Configure ...
^^^^^^^^^^^^^^^^^^^^^^^^

Create a playbook

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat playbook.yml
   - hosts: test_01
     become: true
     roles:
       - __GITHUB_USERNAME__.__GALAXY_PROJECT__

Create *host_vars/test_01/XY-task1.yml*

.. code-block:: yaml
   :emphasize-lines: 1,3

   shell> cat host_vars/test_01/XY-task1.yml 
   XY_task1: true
   ...

.. note::
   * When ...
   * See ...


Configure ...

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook playbook.yml -t XY_task1

   TASK [__GITHUB_USERNAME__.__GALAXY_PROJECT__ : task1: Configure ...] **
   ok: [test_01] => (...)

The command is idempotent

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook playbook.yml -t XY_task1
   ...
   PLAY RECAP ******************************************************************
   test_01: ok=6 changed=0 unreachable=0 failed=0 skipped=4 rescued=0 ignored=0
