DOT_DIRS = aws gnupg ssh ssh/control
DOT_DIR_TARGETS = $(DOT_DIRS:%=$(HOME)/.%)
DOT_FILES = zshenv zshrc aws/config \
	ssh/config ssh/known_hosts ssh/authorized_keys \
	gnupg/gpg.conf gnupg/gpg-agent.conf
DOT_FILE_TARGETS = $(DOT_FILES:%=$(HOME)/.%)

XDG_CONFIG_HOME := $(HOME)/.config
XDG_CONFIG_DIRS := $(shell find config -type d -mindepth 1 | sed -e 's,^config/,,')
XDG_CONFIG_DIR_TARGETS := $(XDG_CONFIG_HOME) $(XDG_CONFIG_DIRS:%=$(XDG_CONFIG_HOME)/%)

XDG_CONFIG_FILES := $(shell find config -type f -mindepth 1 | sed -e 's,^config/,,')
XDG_CONFIG_FILE_TARGETS := $(XDG_CONFIG_FILES:%=$(XDG_CONFIG_HOME)/%)

default: install
install: install_xdg_config install_dotfiles install_vim_config
update:  update_dotfiles update_macos update_vim update_bundler update_gems update_npm update_homebrew

install_xdg_config: $(XDG_CONFIG_DIR_TARGETS) $(XDG_CONFIG_FILE_TARGETS)
.PHONY: install_xdg_config

install_dotfiles: $(DOT_DIR_TARGETS) $(DOT_FILE_TARGETS)
.PHONY: install_dotfiles

install_vim_config: $(HOME)/.vim $(HOME)/.vimrc
.PHONY: install_vim_config

$(HOME)/.vim:
	git clone --recursive git@github.com:mathie/.vim.git $@

$(HOME)/.vimrc: $(HOME)/.vim/vimrc
	ln -snf "$<" "$@"

$(XDG_CONFIG_DIR_TARGETS) $(DOT_DIR_TARGETS):
	install -d -m 0700 $(XDG_CONFIG_DIR_TARGETS) $(DOT_DIR_TARGETS)

$(XDG_CONFIG_HOME)/%: config/%
	ln -snf "$(PWD)/$<" "$@"

$(HOME)/.%: %
	ln -snf "$(PWD)/$<" "$@"

update_dotfiles:
	git pull && \
		$(MAKE) install

update_macos:
	softwareupdate --install --all

update_vim: $(HOME)/.vim
	cd "$<" && \
		git pull && \
		git submodule update --init --recursive

update_homebrew:
	brew update
	brew bundle
	brew outdated

update_bundler:
	bundle update

update_gems:
	[ -x $$(which gem) ] && gem update || true

update_npm:
	[ -x $$(which npm) ] && npm -g update || true
