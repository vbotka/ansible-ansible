# ansible_lib

[![quality](https://img.shields.io/ansible/quality/39556)](https://galaxy.ansible.com/vbotka/ansible_lib)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-lib.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-lib)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-lib)](https://github.com/vbotka/ansible-lib/tags)

[Ansible role.](https://galaxy.ansible.com/vbotka/ansible_lib/) Library of Ansible tasks.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-lib/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Description

This role is a collection of independent tasks. The purpose is providing a library of reusable tasks
that can be included in playbooks and other roles. For example,

```yaml
- name: Create groups of reachable and unreachable hosts.
  include_role:
    name: vbotka.ansible_lib
    tasks_from: al_hosts_reachable
```

See the comments in the tasks.


## Requirements and dependencies

### Collections

* community.general


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
