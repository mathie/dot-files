default: install

DOT_FILES = MacOSX gemrc git_template gitconfig gitignore_global tmux.conf zshrc zsh_functions editrc pryrc tmuxinator ackrc my.cnf
BIN_DIR = bin

install: install_dotfiles install_bin_dir install_vim_config

install_dotfiles: $(DOT_FILES) install_ssh_config install_rvm_config
	for i in $(DOT_FILES); do \
		ln -snf `pwd`/$$i ${HOME}/.$$i; \
	done

gitconfig: gitconfig.public gitconfig.private
	cat $^ > $@

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

update: update_dotfiles update_vim update_rvm update_homebrew

update_dotfiles:
	cd ${HOME}/Development/dot-files && \
		git smart-pull && \
		make

update_vim:
	cd ${HOME}/.vim && \
		git smart-pull && \
		git submodule update --init

update_rvm:
	rvm get stable

update_homebrew:
	brew update
	brew outdated
