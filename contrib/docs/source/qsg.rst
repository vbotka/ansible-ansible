.. _qg:

Quick start guide
*****************

For the users who want to try the role quickly, this guide provides
an example of how to ...


* Install the role ``__GITHUB_USERNAME__.__PROJECT__`` ::

    shell> ansible-galaxy install __GITHUB_USERNAME__.__PROJECT__


* Create the playbook ``__PROJECT__.yml`` for single host srv.example.com (2)

.. code-block:: bash
   :emphasize-lines: 2
   :linenos:

   shell> cat linux-postinstall.yml
   - hosts: srv.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: yes
     become_user: root
     become_method: sudo
     roles:
       - __GITHUB_USERNAME__.__PROJECT__


* Create ``host_vars`` with customized variables

.. code-block:: bash
   :emphasize-lines: 2
   :linenos:

   shell> ls -1 host_vars/srv.example.com/XY-*
   host_vars/srv.example.com/XY-*.yml


* To speedup the execution let's set some variables (2-4) to *false*

.. code-block:: bash
   :emphasize-lines: 2-4
   :linenos:

   shell> cat host_vars/srv.example.com/XY-common.yml
   XY_debug: false
   XY_backup_conf: false
   XY_flavors_enable: false

   ...


* Test syntax ::

    shell> ansible-playbook __PROJECT__.yml --syntax-check


* See what variables will be included ::

    shell> ansible-playbook __PROJECT__.yml -t lp_debug -e lp_debug=True


* Install packages ::

    shell> ansible-playbook __PROJECT__.yml -t lp_packages


* Dry-run, display differences and display variables ::

    shell> ansible-playbook __PROJECT__.yml -e lp_debug=True --check --diff


* Run the playbook ::

    shell> ansible-playbook __PROJECT__.yml


.. warning:: The host has not been secured by this playbook and should
             be used for testing only.
