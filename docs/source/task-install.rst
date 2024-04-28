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


.. warning::

   By default, *ma_pkg_install*, *ma_pip_install*, and
   *ma_venv_install* are mutually exclusive. Disable
   *ma_sanity_pip_exclusive* if you want to install more options in
   the same play.


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

.. warning::

   `Conclusions. The pip module isn't always idempotent #28952 <https://github.com/ansible/ansible/issues/28952>`_
   Quoting: "Managing system site-packages with Pip is not a good idea
   and will probably break your OS. Those should be solely managed by
   the OS package manager (apt/yum/dnf/etc.). If you want to manage
   env for some software in Python, better use a virtualenv technology."

     
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
