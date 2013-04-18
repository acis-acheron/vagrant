if test -z "$HOST_INFO_SH"; then
HOST_INFO_SH=yes

HOSTNAME="$(hostname)"

IS_ALPHA=false
IS_BETA=false
case "$HOSTNAME" in
    "vagrant-alpha")
        export IS_ALPHA=true
        ;;
    "vagrant-beta")
        export IS_BETA=true
        ;;
    *)
        echo "Error: Unknown hostname" 1>&2
        return 1
        ;;
esac

fi # $HOST_INFO_SH
