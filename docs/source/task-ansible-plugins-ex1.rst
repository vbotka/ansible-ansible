Example 1: Install Ansible plugins
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
   map_vbotka_ver: 1.7.0
   map_vbotka_sha256: "sha256:c794517999ae83eea615cb65e337e8c7b9ce2636b34d75c625641f8b804bcc03"
   ma_plugins:
     - archive: ansible-plugins-{{ map_vbotka_ver }}.tar.gz
       archive_url: https://github.com/vbotka/ansible-plugins/archive/{{ map_vbotka_ver }}.tar.gz
       checksum: "{{ map_vbotka_sha256 }}"
       dest: ansible-plugins-{{ map_vbotka_ver }}
       link: ansible-plugins
       plugins:
         - path: ansible-plugins/filter_plugins/dict_filters
           ini_key: filter_plugins
           enable: true
         - path: ansible-plugins/filter_plugins/hash_filters
           ini_key: filter_plugins
           enable: true
         - path: ansible-plugins/filter_plugins/list_filters
           ini_key: filter_plugins
           enable: true

Install plugins

.. code-block:: yaml
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -t ma_plugins
   ...
   TASK [vbotka.ansible : plugins: Debug ma_plugins_paths_list] *********
   ok: [planb] => (item=filter_plugins) => {
       "msg": {
           "filter_plugins": {
               "paths": [
                   "ansible-plugins/filter_plugins/dict_filters", 
                   "ansible-plugins/filter_plugins/hash_filters", 
                   "ansible-plugins/filter_plugins/list_filters", 
               ]
           }
       }
   }

Show the installed plugins at the remote host

.. code-block:: yaml
   :emphasize-lines: 1

   test_01> tree /usr/local/ansible/plugins/ansible-plugins/filter_plugins/
   /usr/local/ansible/plugins/ansible-plugins/filter_plugins/
   ├── dict_filters
   │   └── dict_filters.py
   ├── hash_filters
   │   └── hash_filters.py
   └── list_filters
       └── list_filters.py
