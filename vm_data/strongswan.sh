if test -z "$STRONGSWAN_SH"; then
STRONGSWAN_SH=yes

. "$(pwd)"/aptitude.sh
. "$(pwd)"/backports.sh

SS_URL=svn://svn.forge.objectweb.org/svnroot/contrail/trunk/resource/strongswan

apti subversion libjansson-dev build-essential automake libtool libgmp3-dev \
     libsoup2.4-dev bison flex gperf libreadline-dev

if test ! -d "strongswan_styx"; then
    svn checkout $SS_URL strongswan_styx
    cd "strongswan_styx/strongswan"
    ./autogen.sh
    ./configure --prefix=/usr --sysconfdir=/etc --enable-styx
    make
    cd -
fi

cd "strongswan_styx/strongswan"
make install
cd -

fi #STRONGSWAN_SH
