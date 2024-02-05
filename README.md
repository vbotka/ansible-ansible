# ansible

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/ansible)[![Build Status](https://app.travis-ci.com/vbotka/ansible-ansible.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-ansible)[![Documentation Status](https://readthedocs.org/projects/ansible-ansible/badge/?version=latest)](https://ansible-ansible.readthedocs.io/en/latest/?badge=latest)

[Ansible role](https://galaxy.ansible.com/vbotka/ansible/). Install and configure [Ansible](https://github.com/ansible/ansible).

[Documentation at readthedocs.io](https://ansible-ansible.readthedocs.io)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-ansible/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Supported platforms

This role has been developed and tested with
* [Ubuntu Supported Releases](http://releases.ubuntu.com/)
* [FreeBSD Supported Production Releases](https://www.freebsd.org/releases/)


## Requirements

### Roles

* vbotka.ansible_lib

### Collections

* ansible.posix
* community.general

Note: The collection *ansible.posix* is needed for some playbooks and
roles in *contrib*

## Role Variables

Review the defaults and examples in vars.


## Plugins

No plugins are installed by default. Variable default is *ma_plugins:
[ ]*. Examples how to configure plugins can be found in
vars/main.yml.sample

To activate installed plugins use template *ansible-plugins.cfg.j2*
and configure *_plugins in *ansible.cfg*

```yaml
ma_config_type: template
ma_config_template_default: ansible-plugins.cfg.j2
```


## Check mode

Check mode will fail if the directories *ma_plugins_path* and
*ma_src_path* are missing. To avoid the failure create the directories
first

```bash
shell> ansible-playbook ansible.yml -t ma_plugins_path,ma_src_path
```

If you want to download the repository and the release notes create
also directories *ma_repo_path* and *ma_rnotes_path*

```bash
shell> ansible-playbook ansible.yml -t ma_repo_path,ma_rnotes_path
```

Check mode will fail for the first time when there are plugins
configured in *ma_plugins* and the archives haven't been downloaded
yet. To avoid the failure download the archives first

```bash
shell> ansible-playbook ansible.yml -t ma_plugins_download
```

Then check the playbook and the roles, and see what will be changed

```bash
shell> ansible-playbook ansible.yml --check --diff
```


### Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```

## References

- [Ansible](http://docs.ansible.com/)
- [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)
- [Working With Plugins](https://docs.ansible.com/ansible/latest/plugins/plugins.html#working-with-plugins)
- [Mitogen for Ansible](https://mitogen.networkgenomics.com/ansible_detailed.html)
- [Mitogen Release Notes](https://mitogen.networkgenomics.com/changelog.html)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
