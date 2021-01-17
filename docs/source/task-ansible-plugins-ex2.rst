.. _ug_task_ansible_plugins_ex2:

Example 2: Install Mitogen plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a playbook

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat ansible.yml
   - hosts: test_01
     become: true
     roles:
       - vbotka.ansible

Create *host_vars/test_01/ansible-plugins.yml* 

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat host_vars/test_01/ansible-plugins.yml
   map_mitogen_ver: 0.2.9
   map_mitogen_sha256: "sha256:76cb9afef92596818a4639afb2a0bb0384ce7b6699b353af55662057b08b1e57"
   ma_plugins:
     - archive: mitogen-{{ map_mitogen_ver }}.tar.gz
       archive_url: https://networkgenomics.com/try/mitogen-{{ map_mitogen_ver }}.tar.gz
       checksum: "{{ map_mitogen_sha256 }}"
       dest: mitogen-{{ map_mitogen_ver }}
       link: mitogen
       plugins:
         - path: mitogen/ansible_mitogen/plugins/strategy
           ini_key: strategy_plugins
           enable: true

Install plugins

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -t ma_plugins
   ...
   TASK [vbotka.ansible : plugins: Debug ma_plugins_paths_list] *********
   ok: [planb] => (item=filter_plugins) => {
       "msg": {
           "strategy_plugins": {
	       "paths": [
                   "mitogen/ansible_mitogen/plugins/strategy"
               ]
           }
       }
   }
 
Show the installed plugins at the remote host

.. code-block:: sh
   :emphasize-lines: 1

   shell> tree /usr/local/ansible/plugins/mitogen/ansible_mitogen/plugins/
   /usr/local/ansible/plugins/mitogen/ansible_mitogen/plugins/
   ├── action
   │   ├── __init__.py
   │   ├── mitogen_fetch.py
   │   ├── mitogen_fetch.pyc
   │   └── mitogen_get_stack.py
   ├── connection
   │   ├── __init__.py
   │   ├── mitogen_buildah.py
   │   ├── mitogen_doas.py
   │   ├── mitogen_docker.py
   │   ├── mitogen_jail.py
   │   ├── mitogen_kubectl.py
   │   ├── mitogen_local.py
   │   ├── mitogen_local.pyc
   │   ├── mitogen_lxc.py
   │   ├── mitogen_lxd.py
   │   ├── mitogen_machinectl.py
   │   ├── mitogen_setns.py
   │   ├── mitogen_ssh.py
   │   ├── mitogen_ssh.pyc
   │   ├── mitogen_sudo.py
   │   └── mitogen_su.py
   ├── __init__.py
   └── strategy
       ├── __init__.py
       ├── mitogen_free.py
       ├── mitogen_host_pinned.py
       ├── mitogen_linear.py
       ├── mitogen_linear.pyc
       └── mitogen.py
