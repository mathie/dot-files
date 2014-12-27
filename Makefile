default: install

DOT_FILES = MacOSX git_template gitconfig gitignore_global tmux.conf \
						zshenv zshrc zsh_functions editrc pryrc tmuxinator ackrc my.cnf \
						bashrc bash_profile sleepwatcher offlineimaprc guard.rb railsrc \
						irbrc synergy.conf htoprc jrnl_config
BIN_DIR = bin

install: install_dotfiles install_bin_dir install_vim_config

install_dotfiles: $(DOT_FILES) install_ssh_config install_bundler_config
	for i in $(DOT_FILES); do \
		ln -snf `pwd`/$$i ${HOME}/.$$i; \
	done

gitconfig: gitconfig.public gitconfig.private
	cat $^ > $@

install_ssh_config:
	mkdir -p ${HOME}/.ssh/control
	ln -snf `pwd`/ssh_config ${HOME}/.ssh/config
	ln -snf `pwd`/authorized_keys ${HOME}/.ssh/authorized_keys

install_bundler_config:
	mkdir -p ${HOME}/.bundle
	ln -snf `pwd`/bundler_config ${HOME}/.bundle/config

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

update: update_dotfiles update_vim update_bundler update_gems update_npm update_homebrew

update_dotfiles:
	cd ${HOME}/Development/Personal/dot-files && \
		git remote update && git rebase -p && \
		make

update_vim:
	cd ${HOME}/.vim && \
		git remote update && git rebase -p && \
		git submodule update --init

update_homebrew:
	brew update
	brew outdated

update_bundler:
	bundle update

update_gems:
	[ -x $$(which gem) ] && gem update || true

update_npm:
	[ -x $$(which npm) ] && npm -g update || true
