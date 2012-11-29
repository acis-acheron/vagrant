if test -z "$STRONGSWAN_SH"; then
STRONGSWAN_SH=yes

. "$(pwd)"/aptitude.sh
. "$(pwd)"/backports.sh

apti subversion libjansson-dev build-essential automake libtool libgmp3-dev \
     libsoup2.4-dev bison flex gperf libreadline-dev

TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
svn checkout \
    svn://svn.forge.objectweb.org/svnroot/contrail/trunk/resource/strongswan \
    strongswan_styx
cd -; cd "$TEMP_DIR/strongswan_styx/strongswan"
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc --enable-styx
make
make install
cd -
rm -rf "$TEMP_DIR"

fi #STRONGSWAN_SH
