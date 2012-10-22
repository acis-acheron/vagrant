if test -z "$SHELL_FEATURES_SH"; then
SHELL_FEATURES_SH=yes

. "$(pwd)"/aptitude.sh

# zsh shell
apti zsh
chsh -s /usr/bin/zsh vagrant

# text editors
apti vim emacs23-nox

# Ben's configuration files
apti git-core
TEMP_DIR="$(mktemp -d)"
cd "$TEMP_DIR"
git clone git://github.com/PiPeep/dotfiles.git dotfiles_repo
cd -; cd "$TEMP_DIR/dotfiles_repo"
git submodule update --init
chown vagrant "$TEMP_DIR"
sudo -u vagrant ./install.sh -d
cd -
rm -rf TEMP_DIR

fi # $SHELL_FEATURES_SH
