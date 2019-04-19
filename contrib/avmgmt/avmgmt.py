#!/usr/bin/python3

# AVMGMT (Ansible vault management).
#
# Encrypt and format a string to the format that can be included in
# ansible-playbook YAML files.
#
# Format of files.
# AVMGMT_VAR_FILE: user; host; variable
# AVMGMT_PASSWD_FILE: secret
#
# Ref: Use encrypt_string to create encrypted variables to embed in yaml
# http://docs.ansible.com/ansible/latest/user_guide/vault.html#use-encrypt-string-to-create-encrypted-variables-to-embed-in-yaml

import subprocess
import os

AVMGMT_DIR = '/home/admin/.avmgmt'
AVMGMT_PASSWD_FILE = 'passwd.avmgmt'
AVMGMT_VAR_FILE = 'var.avmgmt'
AVMGMT_VAR_FILE_SEPARATOR = ';'
AVMGMT_VAULT_DIR = '/home/admin/.ansible/vault'
AVMGMT_VAULT_PASSWD_FILE = '/home/admin/.vault_pass.txt'
AVMGMT_VAULT_FILE_MASK = 0o600
AVMGMT_VAULT_FILE_EXT = 'yml'
AVMGMT_VAULT_ID = 'default'

v = open(AVMGMT_DIR + '/' + AVMGMT_VAR_FILE, 'r')
p = open(AVMGMT_DIR + '/' + AVMGMT_PASSWD_FILE, 'r')

for line1, line2 in zip(v,p):
    line1 = line1.rstrip()
    l = line1.split(AVMGMT_VAR_FILE_SEPARATOR)
    secret = line2.rstrip()
    vault_command = 'ansible-vault encrypt_string --encrypt-vault-id=' + AVMGMT_VAULT_ID + ' --vault-password-file=' + AVMGMT_VAULT_PASSWD_FILE + ' ' + secret + ' --name '  + l[2]
    vault_file = AVMGMT_VAULT_DIR + '/' + l[0] + '@' + l[1] + ':' + l[2] + '.' + AVMGMT_VAULT_FILE_EXT
    # print("%s\n %s\n %s\n" % (vault_file, secret, vault_command))
    try:
        output = subprocess.check_output([vault_command], shell=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as exception:
        print(exception.output)
    # print(output.decode('utf-8'))
    os.umask(0)
    with open(os.open(vault_file, os.O_CREAT | os.O_WRONLY, AVMGMT_VAULT_FILE_MASK), 'w') as f:
        f.write('%s' % output.decode('utf-8'))
        f.close()

# EOF
