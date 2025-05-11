====================================
vbotka.ansible_lib 2.6 Release Notes
====================================

.. contents:: Topics


2.6.4
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Fix reserved names.


2.6.3
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add variable al_role_version
* Update tasks/debug.yml

Bugfixes
--------


2.6.2
=====

Release Summary
---------------
Ansible 2.17 feature and bugfix update.

Major Changes
-------------
* Supported add Freebsd 13.3, 14.0, and 14.1
* Supported add Ubuntu 24.04 Noble

Minor Changes
-------------
* Update README. Fix README tag badge.
* Use default rules in local ansible-lint config.
* Update skip_list in local ansible-lint config.
* Update al_pws_user_host; add sanity dependencies; move defaults to
  defaults/main/al_pws.yml; update al_pws_query_result
* defaults moved from main.yml to separate files in main.

Bugfixes
--------
* Make unique list of files for the lookup first_found


2.6.1
=====

Release Summary
---------------
Fix Ansible lint.


2.6.0
=====

Release Summary
---------------
Ansible 2.16 update

Major Changes
-------------

Minor Changes
-------------

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------
