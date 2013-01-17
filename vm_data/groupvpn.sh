if test -z "$GROUPVPN_SH"; then
GROUPVPN_SH=yes

. "$(pwd)"/aptitude.sh

# Backup the resolv.conf file which groupvpn replaces
cp /etc/resolv.conf /etc/resolv.conf.bak

apti mono-complete resolvconf
debi ipop-squeeze.deb
groupvpn_prepare.sh demo-groupvpn-config.zip
/etc/init.d/groupvpn.sh start

# Fix the resolv.conf from our backup, use resolvconf
resolvconf -a eth0 < /etc/resolv.conf.bak

fi # $GROUPVPN_SH
