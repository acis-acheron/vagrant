#/bin/sh

if test `whoami` != "root"; then
    echo "This script should be run as root"
fi

if ! command -v curl; then
    aptitude -y install curl
fi

echo "deb http://www.grid-appliance.org/files/packages/deb/ stable contrib" \
     > /etc/apt/sources.list.d/grid_appliance.list
curl "http://www.grid-appliance.org/files/packages/deb/repo.key" | \
     apt-key add -
aptitude update
aptitude -y install ipop
groupvpn_prepare.sh "$1"
/etc/init.d/groupvpn.sh start
