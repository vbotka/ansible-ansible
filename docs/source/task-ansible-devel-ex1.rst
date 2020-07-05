Example 1: Ansible checkout repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a playbook

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat ansible.yml
   - hosts: test_01
     become: true
     roles:
       - vbotka.ansible

Create *host_vars/test_01/ansible.yml* 

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat host_vars/test_01/ansible.yml
   ma_devel: true
   ma_repo_dir: /scratch/ansible
   ma_repo_version: devel

Checkout repository to the directory */scratch/ansible-git* and checkout branch *devel*

.. code-block:: yaml
   :emphasize-lines: 1

   shell> > ansible-playbook ansible.yml -t ma_devel_repo
   ...
   TASK [vbotka.ansible : devel: Create directory /scratch/ansible] **********************
   skipping: [test_01]

   TASK [vbotka.ansible : devel: Checkout devel] *****************************************
   skipping: [test_01]

   
Show the installed repo

.. code-block:: yaml
   :emphasize-lines: 1

   test_01> ls -1 /scratch/ansible
   bin
   changelogs
   COPYING
   docs
   examples
   hacking
   lib
   licenses
   Makefile
   MANIFEST.in
   packaging
   README.rst
   requirements.txt
   setup.py
   shippable.yml
   test
