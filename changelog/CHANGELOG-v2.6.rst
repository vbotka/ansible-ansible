================================
vbotka.ansible 2.6 Release Notes
================================

.. contents:: Topics


2.6.15
======

Release Summary
---------------
Contrib update.

Major Changes
-------------

Minor Changes
-------------
* Update contrib/rolemaster
* Update contrib/playbooks/modules-in-playbook.yml
* Update contrib/playbooks/modules-in-role.yml

2.6.14
======

Release Summary
---------------
Maintenance update

Major Changes
-------------
* Add support for Ubuntu 24.04 Noble

Minor Changes
-------------
* Add variable ma_role_version
* Update tasks debug.yml


2.6.13
======

Release Summary
---------------
Ansible 2.17 maintenance and bugfix release including docs update.

Major Changes
-------------
* Add support of FreeBSD 14.1

Minor Changes
-------------
* Bump docs 2.6.13
* Remove obsolete comment from docs/source/conf.py
* Update README
* Ansible-lint automatic --fix

Bugfixes
--------
* docs labels levels
* contrib/workbench bugfix release


2.6.12
======

Release Summary
---------------
docs update.

Major Changes
-------------

Minor Changes
-------------
* Exclude docs from local ansible-lint
* Update docs
* Update contrib/docs
* Add contrib/docs/init.sh
* Formatting
* Fix README tag badge
* Use default rules in local ansible-lint config.
* Update skip_list in local ansible-lint config.
* Fix Ansible lint become_method in contrib playbooks.


2.6.11
======

Release Summary
---------------
Support FreeBSD 13.3 and 14.0. Support Python virtual environment.

Major Changes
-------------
* Support FreeBSD 13.3 and 14.0
* Add tasks venv.yml. Support Python virtual environment.
* Add tasks sanity.yml. Add variables ma_sanity*

Minor Changes
-------------
* travis.yml formatting.
* Add ma_debug to the name of debug task.
* Add 9. to ma_rnotes_build_list
* Add 2.16 to ma_rnotes_core_list
* Fix package tasks names.
* Update contrib/rolemaster/templates/travis.yml.j2
* Update debug.yml
* Update docs

Breaking Changes / Porting Guide
--------------------------------
* Variable ma_install renamed to ma_pkg_install
* Add ma_pip_install, ma_venv_install
* Variables ma_packages and ma_pip_packages changed from a list to a
  list of dictionaries.
* Add variables ma_packages_state and ma_pip_packages_state
* Tasks configure.yml renamed to config.yml
* Include config.yml only if ma_config not empty.
* Tasks packages.yml renamed to pkg.yml
* Tag ma_packages renamed to ma_pkg


2.6.10
======

Release Summary
---------------
Fix README. Update docs.


2.6.9
=====

Release Summary
---------------
Formatting.


2.6.8
=====

Release Summary
---------------
Formatting.


2.6.7
=====

Release Summary
---------------
Fix dependencies.


2.6.6
=====

Release Summary
---------------
Fix Ansible lint.


2.6.5
=====

Release Summary
---------------
Update contrib/workbench. Tested OK.

Minor Changes
-------------
* Bump docs version 2.6.5


2.6.4
=====

Release Summary
---------------
Bug fix. Docs update.

Minor Changes
-------------
* Bump docs version 2.6.4
* Update docs

Bugfixes
--------
* Bump readthedocs-sphinx-search from 0.3.1 to 0.3.2 in /docs #1


2.6.3
=====

Release Summary
---------------
Update docs requirements readthedocs-sphinx-search==0.3.2


2.6.2
=====

Release Summary
---------------
Update documentation.

Major Changes
-------------

Minor Changes
-------------
* Bump docs version 2.6.2
* Update docs


2.6.1
=====

Release Summary
---------------
Update documentation.

Major Changes
-------------

Minor Changes
-------------
* Bump docs version 2.6.1
* Update docs
* Update README
* Update tasks/vars. Use ansible_parent_role_paths instead of
  role_path


2.6.0
=====

Release Summary
---------------
Ansible 2.16 update

Major Changes
-------------
- Supported FreeBSD: 12.4, 13.2, 14.0
- Supported Ubuntu: focal, jammy, lunar, mantic

Minor Changes
-------------

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------
