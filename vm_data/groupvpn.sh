if test -z "$GROUPVPN_SH"; then
GROUPVPN_SH=yes

# Backup the resolv.conf file which groupvpn replaces
cp /etc/resolv.conf /etc/resolv.conf.bak

# Use the script from our documents repository
./install_groupvpn.sh demo-groupvpn-config.zip

# Fix the resolv.conf from our backup, use resolvconf
resolvconf -a eth0 < /etc/resolv.conf.bak

fi # $GROUPVPN_SH
