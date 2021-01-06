.. _ug:

############
User's guide
############
.. contents:: Table of Contents
   :depth: 4


.. _ug_introduction:

************
Introduction
************

* Ansible role: `__PROJECT__ <https://galaxy.ansible.com/__GITHUB_USERNAME__/__PROJECT__/>`_
* Supported systems: `Ubuntu <http://releases.ubuntu.com/>`_
* Requirements: `ansible_lib <https://galaxy.ansible.com/__GITHUB_USERNAME__/ansible_lib>`_


.. _ug_installation:

************
Installation
************

The most convenient way how to install an Ansible role is to use
:index:`Ansible Galaxy` CLI ``ansible-galaxy``. The utility comes with the
standard Ansible package and provides the user with a simple interface
to the Ansible Galaxy's services. For example, take a look at the
current status of the role

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-galaxy info __GITHUB_USERNAME__.__PROJECT__

and install it

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-galaxy install __GITHUB_USERNAME__.__PROJECT__

Install the library of tasks

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-galaxy install __GITHUB_USERNAME__.ansible_lib

.. seealso::
   * To install specific versions from various sources see `Installing content <https://galaxy.ansible.com/docs/using/installing.html>`_.
   * Take a look at other roles ``shell> ansible-galaxy search --author=__GITHUB_USERNAME__``


.. _ug_playbook:

********
Playbook
********

Below is a simple playbook that calls this role (10) at a single host
srv.example.com (2)

.. code-block:: bash
   :emphasize-lines: 1
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

.. note:: ``gather_facts: true`` (3) must be set to gather facts
   needed to evaluate :index:`OS-specific options` of the role. For example, to
   install packages, the variable ``ansible_os_family`` is needed to
   select the appropriate Ansible module.

.. seealso::
   * For details see `Connection Plugins <https://docs.ansible.com/ansible/latest/plugins/connection.html>`__ (4-5)
   * See also `Understanding Privilege Escalation <https://docs.ansible.com/ansible/latest/user_guide/become.html#understanding-privilege-escalation>`__ (6-8)


.. _ug_debug:

*****
Debug
*****

Many tasks will display additional information when the variable
:index:`XY_debug` is enabled. Enable debug output either in the
configuration

.. code-block:: yaml
   :emphasize-lines: 1

   XY_debug: true

, or set the extra variable in the command

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -e lp_debug=true

.. note:: The debug output of this role is optimized for the **yaml**
   callback plugin. Set this plugin for example in the environment
   ``shell> export ANSIBLE_STDOUT_CALLBACK=yaml``.

.. seealso:: * `Playbook Debugger <https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html>`_


.. _ug_tags:

****
Tags
****

The :index:`tags` provide the user with a very useful tool to run selected
tasks of the role. To see what tags are available list the tags of the
role with the command

.. include:: tags-list.rst


Examples
========

* Display the list of the variables and their values with the tag
  ``XY_debug`` (when the :index:`debug` is enabled ``XY_debug: true``)

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook __PROJECT__.yml -t lp_debug

* See what packages will be installed

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook __PROJECT__.yml -t lp_packages --check

* Install packages and exit the play

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook __PROJECT__.yml -t lp_packages


.. _ug_tasks:

*****
Tasks
*****

.. seealso::
   * Source code :ref:`as_main.yml`

Development and testing
=======================

In order to deliver an Ansible project it's necessary to test the code
and configuration. The tags provide the administrators with a tool to
test single tasks' files and single tasks. For example, to test single
tasks at single remote host *test_01*, create a playbook

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat linux-postinstall.yml
   - hosts: test_01
     become: true
     roles:
       - __GITHUB_USERNAME__.__PROJECT__

Customize configuration in ``host_vars/test_01/XY-*.yml`` and :index:`check the syntax`

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml --syntax-check

Then :index:`dry-run` the selected task and see what will be
changed. Replace <tag> with valid tag or with a comma-separated list
of tags

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t <tag> --check --diff

When all seems to be ready run the command. Run the command twice and
make sure the playbook and the configuration is :index:`idempotent`

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t <tag>

.. seealso::
   * Periodically run playbooks from cron by *ansible-runner*
     `ansible-cron-audit.bash <https://github.com/__GITHUB_USERNAME__/ansible-runner/blob/master/contrib/ansible-cron-audit.bash>`_
   * *ansible-runner* wrapper
     `arwrapper.bash <https://github.com/__GITHUB_USERNAME__/ansible-runner/blob/master/contrib/arwrapper.bash>`_
   

.. _ug_task_task1:
.. include:: task-task1.rst
.. toctree::
   :name: task1_toc

   task-task1-ex1
   task-task1-ex2

.. _ug_task_task1_ex1:
.. include:: task-task1-ex1.rst
.. _ug_task_task2_ex2:
.. include:: task-task1-ex2.rst


.. _ug_vars:

*********
Variables
*********

.. seealso::
   * `Ansible variable precedence: Where should I put a variable?
     <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_

.. _ug_vars_defaults:
.. include:: vars-defaults.rst
.. _ug_vars_os_defaults:
.. include:: vars-os-defaults.rst
.. _ug_vars_os_custom:
.. include:: vars-os-custom.rst
.. _ug_vars_flavors:
.. include:: vars_flavors.rst


.. _ug_bp:

*************
Best practice
*************

.. _ug_bp_firstboot:

Recommended configuration after the installation of OS
======================================================

Test syntax

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml --syntax-check

See what variables will be included

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t XY_debug -e XY_debug=True

:index:`Dry-run`, display differences and display variables

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -e XY_debug=True --check --diff

Configure hostname, users, sudoers, network and reboot

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t XY_task1

Test the installation of packages

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t lp_packages -e lp_package_install_dryrun=True

Install packages

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml -t lp_packages

Run the playbook

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook __PROJECT__.yml

Test the :index:`idem-potency`. The role and the configuration data shall be
idempotent. Once the installation and configuration have passed there
should be no changes reported by *ansible-playbook* when running the
playbook repeatedly. Disable debug, and install to speedup the
playbook and run the playbook again.

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook __PROJECT__.yml

.. _ug_bp_flavors:

Flavors
=======

 <TBD>
