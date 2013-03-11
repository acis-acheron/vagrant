if test -z "$HOST_INFO_SH"; then
HOST_INFO_SH=yes

HOSTNAME="$(hostname)"

IS_ALICE=false
IS_BOB=false
case "$HOSTNAME" in
    "vagrant-alice")
        export IS_ALICE=true
        ;;
    "vagrant-bob")
        export IS_BOB=true
        ;;
    *)
        echo "Error: Unknown hostname" 1>&2
        return 1
        ;;
esac

fi # $HOST_INFO_SH
