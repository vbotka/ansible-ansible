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

Run this role to install and configure Ansible. Optionally, install
Ansible plugins, checkout repo with the source code, and download the
Ansible release notes.

* Ansible role: `ansible <https://galaxy.ansible.com/vbotka/ansible/>`_

* Supported systems:
  
  * `FreeBSD Supported Production Releases <https://www.freebsd.org/releases/>`_

  * `Ubuntu Supported Releases <http://releases.ubuntu.com/>`_

* Requirements:

  * `ansible_lib <https://galaxy.ansible.com/vbotka/ansible_lib>`_
  * `community.general <https://docs.ansible.com/ansible/latest/collections/community/general/>`_

.. seealso::
   * `Ansible project documentation <https://docs.ansible.com/>`_
   * `Ansible project source code <https://github.com/ansible>`_
   * `Other Tools And Programs <https://docs.ansible.com/ansible/latest/community/other_tools_and_programs.html#other-tools-and-programs>`_


.. _ug_installation:

************
Installation
************

The most convenient way how to install an Ansible role is to use
Ansible Galaxy CLI ``ansible-galaxy``. The utility comes with the
standard Ansible package and provides the user with a simple interface
to the Ansible Galaxy's services. For example, take a look at the
current status of the role ::

   shell> ansible-galaxy role info vbotka.ansible

and install it ::

    shell> ansible-galaxy role install vbotka.ansible

Install the library ::

    shell> ansible-galaxy role install vbotka.ansible_lib

and install the collection if necessary ::

    shell> ansible-galaxy collection install community.general

.. seealso::

   * To install specific versions from various sources see `Installing content <https://galaxy.ansible.com/docs/using/installing.html>`_

   * Take a look at other roles ``shell> ansible-galaxy search --author=vbotka``


.. _ug_playbook:

********
Playbook
********

Below is a simple playbook that calls this role (10) at a single host
srv.example.com (2)

.. code-block:: yaml
   :emphasize-lines: 2,10
   :linenos:

   shell> cat ansible.yml
   - hosts: srv.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: true
     become_user: root
     become_method: sudo
     roles:
       - vbotka.ansible

.. note:: ``gather_facts: true`` (3) must be set to gather facts
   needed to evaluate OS-specific options of the role. For example, to
   install packages, the variable ``ansible_os_family`` is needed to
   select the appropriate Ansible module.

.. seealso::

   * For details see `Connection Plugins <https://docs.ansible.com/ansible/latest/plugins/connection.html>`_ (4-5)

   * See also `Understanding Privilege Escalation <https://docs.ansible.com/ansible/latest/user_guide/become.html#understanding-privilege-escalation>`_ (6-8)


.. _ug_debug:

*****
Debug
*****

To see additional debug information enable debug output in the
configuration

.. code-block:: yaml
   :emphasize-lines: 1

   ma_debug: true

, or set the extra variable in the command

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -e ma_debug=true

.. note::

   * The debug output of this role is optimized for the **yaml**
     callback plugin. Set this plugin for example in the environment
     ``shell> export ANSIBLE_STDOUT_CALLBACK=yaml``.

   * See details about the yaml callback plugin ``shell> ansible-doc -t callback yaml``

   * See list of other callback plugins ``shell> ansible-doc -t callback -l``


.. seealso::

   * `Playbook Debugger <https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html>`_


.. _ug_tags:

****
Tags
****

The tags provide the user with a very useful tool to run selected
tasks of the role. To see what tags are available list the tags of the
role:

.. include:: tags-list.rst

For example, display the list of the variables and their values with
the tag ``ma_debug`` (when the debug is enabled ``ma_debug=true``)

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook ansible.yml -t ma_debug -e ma_debug=true

Create directories

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook ansible.yml -t ma_plugins_path,ma_src_path,ma_repo_path,ma_rnotes_path

See what packages will be installed

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook ansible.yml -t ma_packages --check

Install packages and exit the play

.. code-block:: sh
   :emphasize-lines: 1

    shell> ansible-playbook ansible.yml -t ma_packages


.. _ug_tasks:

*****
Tasks
*****

Test single tasks at single remote host *test_01*. Create a playbook

.. code-block:: yaml
   :emphasize-lines: 1

   shell> cat ansible.yml
   - hosts: test_01
     become: true
     roles:
       - vbotka.ansible

Customize configuration in ``host_vars/test_01/ma-*.yml`` and check the syntax

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml --syntax-check

Then dry-run the selected task and see what will be changed. Replace <tag> with valid tag.

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -t <tag> --check --diff

When all seems to be ready run the command. Run the command twice and
make sure the playbook and the configuration is idempotent

.. code-block:: sh
   :emphasize-lines: 1

   shell> ansible-playbook ansible.yml -t <tag>

.. _ug_task_configure:
.. include:: task-configure.rst

.. _ug_task_plugins:
.. include:: task-plugins.rst


Examples
--------

.. toctree::
   :name: ansible_plugins_toc

   task-ansible-plugins-ex1
   task-ansible-plugins-ex2

.. _ug_task_devel:
.. include:: task-devel.rst


Examples
--------

.. toctree::
   :name: ansible_devel_toc

   task-ansible-devel-ex1
   task-ansible-devel-ex2


.. _ug_vars:

*********
Variables
*********

The default variables are stored in the directory **defaults**. OS
specific variables are stored in the directory **vars/defaults**.

.. seealso::

   * Annotated Source code :ref:`as_vars.yml`

   * `Ansible variable precedence: Where should I put a variable? <https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable>`_


.. _ug_defaults:

Default variables
-----------------

  <TBD>

[`defaults/main.yml <https://github.com/vbotka/ansible-ansible/blob/master/defaults/main.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../defaults/main.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:


.. _ug_bp:

*************
Best practice
*************

Test syntax ::

   shell> ansible-playbook pb.yml --syntax-check

Display and review the variables. Then disable debug
``ma_debug=false`` to speedup the playbook ::

   shell> ansible-playbook ansible.yml -t ma_debug -e ma_debug=true

Install packages. Then disable the installation ``ma_install=false``
to speedup the playbook ::

   shell> ansible-playbook ansible.yml -t ma_packages -e ma_install=true

Create directories. The following check would fail without the directories ::

   shell> ansible-playbook ansible.yml -t ma_plugins_dirs,ma_src_path

If you want to download the repository and the release notes create
also these directories ::

   shell> ansible-playbook ansible.yml -t ma_repo_path,ma_rnotes_path

Run the playbook in the check mode and review the changes ::

   shell> ansible-playbook ansible.yml --check --diff

Run the playbook if all seems to be right. The role and the
configuration data in the examples are idempotent. After the
installation and configuration completed there should be no changes
reported by *ansible-playbook* when running the playbook repeatedly ::

    shell> ansible-playbook ansible.yml
