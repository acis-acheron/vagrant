#!/bin/sh

. "$(pwd)"/shell_features.sh # (optional) make ssh friendlier
. "$(pwd)"/strongswan.sh # build and install strongswan (don't configure)
# Installing groupvpn breaks networking?
. "$(pwd)"/groupvpn.sh # install and configure groupvpn
