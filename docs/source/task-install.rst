Install Ansible package
=======================

There are three options:

* Install OS-specific packages
* Install PyPI package
* Install PyPI package in Python virtual environment

By default, nothing will be installed:

.. code-block:: yaml

   ma_pkg_install: false
   ma_pip_install: false
   ma_venv_install: false


By default, the options are mutually exclusive

.. code-block:: yaml

   ma_sanity_pip_exclusive: true


Install OS-specific packages
----------------------------

Dry run the installation and see what will be installed

.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_pkg -e ma_debug=true -e ma_pkg_install=true -CD

If all is right install the package
 
.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_pkg -e ma_debug=true -e ma_pkg_install=true
		
.. seealso::
   * Annotated Source code :ref:`as_pkg.yml`


Install PyPI package
--------------------

Dry run the installation and see what will be installed

.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_pip -e ma_debug=true -e ma_pip_install=true -CD

If all is right install the package
 
.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_pip -e ma_debug=true -e ma_pip_install=true

.. seealso::
   * Annotated Source code :ref:`as_pip.yml`

     
Install PyPI package in Python virtual environment
--------------------------------------------------

Dry run the installation and see what will be installed

.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_venv -e ma_debug=true -e ma_venv_install=true -CD

If all is right install the package
 
.. code-block:: bash

  shell> ansible-playbook ansible.yml -t ma_venv -e ma_debug=true -e ma_venv_install=true

.. seealso::
   * Annotated Source code :ref:`as_venv.yml`
