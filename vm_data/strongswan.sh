if test -z "$STRONGSWAN_SH"; then
STRONGSWAN_SH=yes

. "$(pwd)"/aptitude.sh
. "$(pwd)"/backports.sh
. "$(pwd)"/host_info.sh

SS_URL=svn://svn.forge.objectweb.org/svnroot/contrail/trunk/resource/strongswan

apti subversion libjansson-dev build-essential automake libtool libgmp3-dev \
     libsoup2.4-dev bison flex gperf libreadline-dev

if test ! -e "strongswan_cache.tar"; then
    TEMP_DIR="$(mktemp -d)"
    cd "$TEMP_DIR"
    svn checkout $SS_URL "strongswan_styx"
    cd -
    cd "$TEMP_DIR/strongswan_styx/strongswan"
    ./autogen.sh
    ./configure --sysconfdir=/etc --enable-styx
    make
    cd -
    cd "$TEMP_DIR"
    tar cf strongswan_cache.tar strongswan_styx
    cd -
    cp "$TEMP_DIR/strongswan_cache.tar" .
    rm -rf "$TEMP_DIR"
fi

TEMP_DIR="$(mktemp -d)"
cp strongswan_cache.tar "$TEMP_DIR"
cd "$TEMP_DIR"
tar xf strongswan_cache.tar
cd -
cd "$TEMP_DIR/strongswan_styx/strongswan"
make install

cd -
rm -rf "$TEMP_DIR"

cp -r default-strongswan-config/* /

if $IS_ALICE; then
    cp -r demo-alice-ipsec-certs/* /
elif $IS_BOB; then
    cp -r demo-bob-ipsec-certs/* /
else
    echo "Unknown hostname" 1>&2 
fi

fi #STRONGSWAN_SH
