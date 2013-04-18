#!/bin/sh

. "$(pwd)"/aptitude.sh
. "$(pwd)"/host_info.sh

# Install and configure racoon
DEBIAN_PRIORITY=critical
export DEBIAN_PRIORITY
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apti racoon ipsec-tools

cp -r default-racoon-config/* /
1if $IS_ALPHA; then
    cp -r demo-alpha-ipsec-certs/* /
elif $IS_BETA; then
    cp -r demo-beta-ipsec-certs/* /
else
    echo "Unknown hostname" 1>&2 
fi

# Install and configure IPOP
. "$(pwd)"/groupvpn.sh

cd "$(pwd)"/acheron
./install.sh
cd -