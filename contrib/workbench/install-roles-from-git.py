#!/usr/bin/env python

# Clone a github repo to the current directory. Pull if exists. Read
# the repos from the file requirements.yml.github
#
# Example of requirements.yml.github
# - src: https://github.com/vbotka/ansible-ansible.git
#   name: vbotka.ansible
#
# http://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file
# https://git-scm.com/docs/git-clone
# Try: ansible-galaxy install -r requirements.yml -p ROLE_PATH

import yaml
import subprocess
import os

with open("requirements.github.yml", 'r') as stream:
    try:
        data = yaml.load(stream)
    except yaml.YAMLError as exc:
        print(exc)

for repo in data[:]:
    command_clone = 'git clone ' + repo['src'] + ' ' + repo['name']
    command_pull = 'cd ' + repo['name'] + ' && git pull'
    if os.path.isdir(repo['name']):
        command = command_pull
    else:
        command = command_clone
    print("%s\n" % command)
    try:
        output = subprocess.check_output([command], shell=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as exception:
        print(exception.output)

# EOF
