#!/bin/sh -x
# Reinstall acheron and restart all the services (useful for testing)

/etc/init.d/acheron stop
/etc/init.d/groupvpn.sh stop
/etc/init.d/ipsec stop

cd /config_data/acheron
./install.sh
cd -

/etc/init.d/groupvpn.sh start
/etc/init.d/ipsec start
/etc/init.d/acheron start
