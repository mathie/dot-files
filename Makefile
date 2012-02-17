default: install

DOT_FILES = MacOSX gemrc git_template gitconfig gitignore_global tmux.conf zshrc editrc
BIN_DIR = bin

install: install_dotfiles install_bin_dir install_vim_config

install_dotfiles: install_ssh_config install_rvm_config
	for i in $(DOT_FILES); do \
		ln -snf `pwd`/$$i ${HOME}/.$$i; \
	done

install_ssh_config:
	mkdir -p ~/.ssh/control
	ln -snf `pwd`/ssh_config ${HOME}/.ssh/config

install_rvm_config:
	mkdir -p ~/.rvm/gemsets
	ln -snf `pwd`/global.gems ${HOME}/.rvm/gemsets/global.gems

install_bin_dir:
	mkdir -p ~/bin
	SetFile -a V ~/bin
	for i in $(BIN_DIR)/*; do \
		ln -snf `pwd`/$$i ${HOME}/$$i; \
	done

install_vim_config: ~/.vim ~/.vimrc

~/.vim:
	git clone git@github.com:mathie/.vim.git ~/.vim
	cd ~/.vim && git submodule update --init

~/.vimrc:
	ln -snf ~/.vim/vimrc ~/.vimrc

rvm_install_global_gems:
	for i in $$(rvm list strings|grep -v ^system); do \
		rvm $${i}@global do gem install $$(cat global.gems); \
	done
