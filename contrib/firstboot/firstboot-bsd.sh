#!/bin/sh
#
# All rights reserved (c) 2021-2022, Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause

# VERSION="1.0.1"
USERNAME="admin"

# Install packages
env ASSUME_ALWAYS_YES=YES pkg install security/sudo
env ASSUME_ALWAYS_YES=YES pkg install lang/perl5.32
env ASSUME_ALWAYS_YES=YES pkg install lang/python38
env ASSUME_ALWAYS_YES=YES pkg install security/py-openssl
env ASSUME_ALWAYS_YES=YES pkg install archivers/gtar

# Create user
if (! getent passwd ${USERNAME} > /dev/null); then
    if (pw useradd -n ${USERNAME} -s /bin/sh -m); then
	printf "[OK] user %s created\n" "$USERNAME"
    else
	printf "[ERR] can not create user %s\n" "$USERNAME"
    fi
else
    chmod 0755 /home/${USERNAME}
    printf "[OK] user %s exists\n" "$USERNAME"
fi

# Create directories and files

# $HOME/.ssh
if [ ! -e /home/${USERNAME}/.ssh ]; then
    if (mkdir /home/${USERNAME}/.ssh); then
	printf "[OK] dir /home/%s/.ssh created\n" "$USERNAME"
    else
	printf "[ERR] can not create dir /home/%s/.ssh\n" "$USERNAME"
    fi
else
    printf "[OK] dir /home/%s/.ssh exists\n" "$USERNAME"
fi
[ -e /home/${USERNAME}/.ssh ] && chmod 0700 /home/${USERNAME}/.ssh

# $HOME/.ssh/authorized_keys
[ ! -e /home/${USERNAME}/.ssh/authorized_keys ] && \
    touch /home/${USERNAME}/.ssh/authorized_keys
[ -e /home/${USERNAME}/.ssh/authorized_keys ] && \
    chmod 0600 /home/${USERNAME}/.ssh/authorized_keys
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Configure sudoers
cp /usr/local/etc/sudoers.dist /usr/local/etc/sudoers
chown root:wheel /usr/local/etc/sudoers
chmod 0440 /usr/local/etc/sudoers
echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# Configure root
# chown root:wheel /root/firstboot.sh

# Configure etc
chown root:wheel /etc/rc.conf
chmod 0644 /etc/rc.conf
chown root:wheel /etc/resolv.conf
chmod 0644 /etc/resolv.conf
if [ -e /etc/rc.d/ezjail.flavour.default ]; then
    chown root:wheel /etc/rc.d/ezjail.flavour.default
    chmod 0755 /etc/rc.d/ezjail.flavour.default
fi

# EOF
