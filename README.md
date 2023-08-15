# ansible

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/ansible)[![Build Status](https://app.travis-ci.com/vbotka/ansible-ansible.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-ansible)[![Documentation Status](https://readthedocs.org/projects/docs/badge/?version=latest)](https://ansible-ansible.readthedocs.io/en/latest/)

[Ansible role](https://galaxy.ansible.com/vbotka/ansible/). Install and configure [Ansible](https://github.com/ansible/ansible).

[Documentation at readthedocs.io](https://ansible-ansible.readthedocs.io)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-ansible/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Supported platforms

This role has been developed and tested with
* [Ubuntu Supported Releases](http://releases.ubuntu.com/)
* [FreeBSD Supported Production Releases](https://www.freebsd.org/releases/)

This may be different from the platforms in Ansible Galaxy which does not offer all
released versions in time and would report an error. For example:
`IMPORTER101: Invalid platform: "FreeBSD-12.2", skipping.`


## Requirements

### Roles

* vbotka.ansible_lib

### Collections

* community.general


## Role Variables

Review the defaults and examples in vars.


## Dependencies

None.


## Plugins

No plugins are installed by default. Variable default is *ma_plugins: [ ]*. Examples how to configure plugins can be found in vars/main.yml .

To activate installed plugins use template *ansible-plugins.cfg.j2* and configure *_plugins in *ansible.cfg* .

```
ma_config_type: "template"
ma_config_template_default: "ansible-plugins.cfg.j2"
```


## Check mode

Check mode will fail if the directories *ma_plugins_path* and *ma_src_path* are missing. To avoid the failure create the directories first

```
shell> ansible-playbook ansible.yml -t ma_plugins_path,ma_src_path
```

If you want to download the repository and the release notes create also directories *ma_repo_path* and *ma_rnotes_path*

```
shell> ansible-playbook ansible.yml -t ma_repo_path,ma_rnotes_path
```

Check mode will fail for the first time when there are plugins configured in *ma_plugins* and the archives haven't been downloaded yet. To avoid the failure download the archives first

```
shell> ansible-playbook ansible.yml -t ma_plugins_download
```

Then check the playbook and the roles, and see what will be changed

```
shell> ansible-playbook ansible.yml -CD
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
