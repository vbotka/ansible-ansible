.. code-block:: bash
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml --list-tags
   
   playbook: __PROJECT__.yml

   play #1 (srv.example.com): srv.example.com TAGS: []
      TASK TAGS: [always, ... ]
