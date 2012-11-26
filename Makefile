default: install

DOT_FILES = MacOSX gemrc git_template gitconfig gitignore_global tmux.conf zshenv zshrc zsh_functions editrc pryrc tmuxinator ackrc my.cnf bashrc bash_profile sleepwatcher offlineimaprc
HOMEBREW_CONFIG_FILES = etc/my.cnf
BIN_DIR = bin

install: install_dotfiles install_homebrew_config_files install_bin_dir install_vim_config install_launchagents

install_dotfiles: $(DOT_FILES) install_ssh_config
	for i in $(DOT_FILES); do \
		ln -snf `pwd`/$$i ${HOME}/.$$i; \
	done

gitconfig: gitconfig.public gitconfig.private
	cat $^ > $@

install_ssh_config:
	mkdir -p ~/.ssh/control
	ln -snf `pwd`/ssh_config ${HOME}/.ssh/config

install_homebrew_config_files:
	for i in $(HOMEBREW_CONFIG_FILES); do \
		ln -snf `pwd`/homebrew/$$i /usr/local/$$i; \
	done

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

install_launchagents:
	for i in LaunchAgents/*.plist; do \
		ln -snf `pwd`/$$i ${HOME}/Library/$$i; \
	done

update: update_dotfiles update_vim update_rbenv update_homebrew update_bundler

update_dotfiles:
	cd ${HOME}/Development/dot-files && \
		git smart-pull && \
		make

update_vim:
	cd ${HOME}/.vim && \
		git smart-pull && \
		git submodule update --init

update_homebrew:
	brew update
	brew outdated

update_rbenv: update_rbenv_main update_rbenv_plugins

update_rbenv_main:
	if [ -d ~/.rbenv ]; then \
		(cd ~/.rbenv; git smart-pull); \
	else \
		git clone git://github.com/sstephenson/rbenv.git ~/.rbenv; \
	fi

update_rbenv_plugins: update_ruby_build

update_ruby_build:
	if [ -d ~/.rbenv/plugins/ruby-build ]; then \
		(cd ~/.rbenv/plugins/ruby-build; git smart-pull); \
	else \
		git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build; \
	fi

update_bundler:
	bundle update
