.. _ug_task_ansible_devel_ex2:

Example 2: Ansible get release notes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
   ma_rnotes_dir: /scratch/ansible-release-notes
   ma_rnotes_list: [ '2.5', '2.6', '2.7', '2.8', '2.9', '2.10']

Get Ansible release notes to the directory */scratch/ansible-release-notes*

.. code-block:: yaml
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -t ma_devel_rnotes
   ...
   TASK [vbotka.ansible : devel: Create directory /scratch/ansible-release-notes] ********
   ok: [test_01]
   
   TASK [vbotka.ansible : devel: Get release notes ['2.5', '2.6', '2.7', '2.8', '2.9', '2.10']]
   ok: [test_01] => (item=2.5)
   ok: [test_01] => (item=2.6)
   ok: [test_01] => (item=2.7)
   ok: [test_01] => (item=2.8)
   ok: [test_01] => (item=2.9)
   ok: [test_01] => (item=2.10)
   
Show the release notes at the remote host

.. code-block:: yaml
   :emphasize-lines: 1

   test_01> tree /scratch/ansible-release-notes
   /scratch/ansible-release-notes
   ├── CHANGELOG-v2.10.rst
   ├── CHANGELOG-v2.5.rst
   ├── CHANGELOG-v2.6.rst
   ├── CHANGELOG-v2.7.rst
   ├── CHANGELOG-v2.8.rst
   └── CHANGELOG-v2.9.rst
