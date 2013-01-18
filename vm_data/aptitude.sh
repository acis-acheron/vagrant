if test -z "$APTITUDE_SH"; then
APTITUDE_SH=yes

. "$(pwd)"/backports.sh

aptitude update

apti() {
    aptitude install -y -q=9 "$@"
}
debi() {
    dpkg -i --force-depends "$@"
}

fi # $APTITUDE_SH
