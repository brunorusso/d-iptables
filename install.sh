#!/bin/bash
cp d-iptables.sh /sbin/d-iptables
chmod 700 /sbin/d-iptables
cp d-iptables.man.8.gz /usr/man/man8
mkdir -p /usr/doc/d-iptables
cp COPYING ChangeLog INSTALL README TODO /usr/doc/d-iptables
