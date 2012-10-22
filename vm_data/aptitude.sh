if test -z "$APTITUDE_SH"; then
APTITUDE_SH=yes

aptitude update

apti() {
    aptitude install -y -q=9 "$@"
}

fi # $APTITUDE_SH
