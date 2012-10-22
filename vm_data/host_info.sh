if test -z "$HOST_INFO_SH"; then
HOST_INFO_SH=yes

HOSTNAME="$(hostname)"

case "$HOSTNAME" in
    "vagrant-alice")
        IS_ALICE=yes
        ;;
    "vagrant-bob")
        IS_BOB=yes
        ;;
    *)
        echo "Error: Unknown hostname" 1>&2
        return 1
        ;;
esac

fi # $HOST_INFO_SH
