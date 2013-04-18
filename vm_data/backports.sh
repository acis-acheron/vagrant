if test -z "$BACKPORTS_SH"; then
BACKPORTS_SH=yes

echo "deb http://backports.debian.org/debian-backports " \
     "squeeze-backports main contrib non-free" > \
     /etc/apt/sources.list.d/backports.list
echo "deb-src http://backports.debian.org/debian-backports " \
     "squeeze-backports main contrib non-free" >> \
     /etc/apt/sources.list.d/backports.list

cat > /etc/apt/preferences.d/backports <<EOF
Package: *
Pin: release a=backports
Pin-Priority: 100
EOF

aptitude update

fi # $BACKPORTS_SH
