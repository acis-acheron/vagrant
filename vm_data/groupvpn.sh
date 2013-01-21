if test -z "$GROUPVPN_SH"; then
GROUPVPN_SH=yes

. "$(pwd)"/aptitude.sh

# Backup the resolv.conf file which groupvpn replaces
cp /etc/resolv.conf /etc/resolv.conf.bak

apti mono-complete resolvconf

RESULT=1
while [ $RESULT -ne 0 ]
do 
  # Force the installation of the ipop package
  if test ! -e "ipop-squeeze.deb.tar"; then
    tar cvf ipop-squeeze.deb.tar ipop-squeeze.deb
  fi

  # Hacktastic Mr. Hacky Hackerson.
  TEMP_DIR="$(mktemp -d)"
  cp ipop-squeeze.deb.tar "$TEMP_DIR"
  cd "$TEMP_DIR"
  tar xvf ipop-squeeze.deb.tar
  dpkg -i --force-depends ipop-squeeze.deb
  RESULT=$?
  cd -
  rm -rf "$TEMP_DIR"
done

# Use apt-get which will opt to install the unmet
# dependencies by default (whereas aptitude will
# opt to remove the ipop package)
apt-get install -fy

groupvpn_prepare.sh demo-groupvpn-config.zip
/etc/init.d/groupvpn.sh start

# Fix the resolv.conf from our backup, use resolvconf
resolvconf -a eth0 < /etc/resolv.conf.bak

fi # $GROUPVPN_SH
