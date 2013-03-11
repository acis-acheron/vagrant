#!/bin/sh

#. "$(pwd)"/shell_features.sh # (optional) make ssh friendlier
. "$(pwd)"/strongswan.sh # build and install strongswan (don't configure)
# Installing groupvpn breaks networking?
. "$(pwd)"/groupvpn.sh # install and configure groupvpn
# Install acheron last
cd acheron; ./install.sh; cd -
/etc/init.d/ipsec start
/etc/init.d/groupvpn.sh start
/etc/init.d/acheron start
