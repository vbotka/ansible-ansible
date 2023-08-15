.. code-block:: bash
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml --list-tags
   
   playbook: ansible.yml

   play #1 (srv.example.com): srv.example.com TAGS: []
       TASK TAGS: [always, ma_ara, ma_config, ma_debug, ma_devel,
       ma_devel_repo, ma_devel_rnotes, ma_packages, ma_plugins,
       ma_plugins_download, ma_plugins_extract, ma_plugins_link,
       ma_plugins_lists, ma_plugins_path, ma_plugins_test_inikeys,
       ma_repo_path, ma_rnotes_path, ma_src_path, ma_vars]
