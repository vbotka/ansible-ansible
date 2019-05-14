Ansible
=======

[![Build Status](https://travis-ci.org/vbotka/ansible-ansible.svg?branch=master)](https://travis-ci.org/vbotka/ansible-ansible)

[Ansible role](https://galaxy.ansible.com/vbotka/ansible/). Install and configure *Ansible*.


Requirements
------------

None.


Role Variables
--------------

Review the defaults and examples in vars.


Dependencies
------------

None.


Plugins
-------

No plugins are isntalled by default. Variable default is *ma_plugins:
[]*. Examples how to configure plugins can be found in vars/main.yml .

To activate installed plugins use template '*ansible-plugins.cfg.j2*"
and configure '*_plugins' in ansible.cfg .

```
ma_config_type: "template"
ma_config_template_default: "ansible-plugins.cfg.j2"
```


References
----------

- [Ansible](http://docs.ansible.com/)
- [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)
- [Working With Plugins](https://docs.ansible.com/ansible/latest/plugins/plugins.html#working-with-plugins)
- [Mitogen for Ansible](https://mitogen.networkgenomics.com/ansible_detailed.html)
- [Mitogen Release Notes](https://mitogen.networkgenomics.com/changelog.html)


License
-------

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


Author Information
------------------

[Vladimir Botka](https://botka.link)
