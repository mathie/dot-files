default: install

DOT_FILES = MacOSX gemrc git_template gitconfig gitignore_global tmux.conf zshrc
BIN_DIR = bin

install: install_dotfiles install_bin_dir

install_dotfiles:
	for i in $(DOT_FILES); do \
		ln -snf `pwd`/$$i ${HOME}/.$$i; \
	done

install_bin_dir:
	mkdir -p ~/bin
	SetFile -a V ~/bin
	for i in $(BIN_DIR)/*; do \
		ln -snf `pwd`/$$i ${HOME}/$$i; \
	done
