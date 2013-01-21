if test -z "$STRONGSWAN_SH"; then
STRONGSWAN_SH=yes

. "$(pwd)"/aptitude.sh
. "$(pwd)"/backports.sh

SS_URL=svn://svn.forge.objectweb.org/svnroot/contrail/trunk/resource/strongswan

apti subversion libjansson-dev build-essential automake libtool libgmp3-dev \
     libsoup2.4-dev bison flex gperf libreadline-dev

# While reading this, you may ask yourself, "Why the hell...?"
# The answer is: VirtualBox shared folders do not play nice with symlinks.
# This entire script is one, giant, ugly, workaround.

if test -d "strongswan_styx"; then
   rm -rf "strongswan_styx"
fi

if test ! -e "strongswan_cache.tar"; then
    TEMP_DIR="$(mktemp -d)"
    cd "$TEMP_DIR"
    svn checkout $SS_URL "strongswan_styx"
    tar cvf strongswan_cache.tar strongswan_styx
    cd -
    cp "$TEMP_DIR/strongswan_cache.tar" .
    rm -rf "$TEMP_DIR"
fi

TEMP_DIR="$(mktemp -d)"
cp strongswan_cache.tar "$TEMP_DIR"
cd "$TEMP_DIR"
tar xvf strongswan_cache.tar
cd -
cd "$TEMP_DIR/strongswan_styx/strongswan"
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc --enable-styx
make
make install

cd -
rm -rf "$TEMP_DIR"

fi #STRONGSWAN_SH
