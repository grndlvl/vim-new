current_directory := $(shell pwd)
explicit := gittemplate.symlink
allsymlinks := $(wildcard *.symlink)
symlinks := $(filter-out $(explicit),$(allsymlinks))

all: install ycm

gitntags:
	sudo apt-get install exuberant-ctags
	ln -s $(current_directory)/gittemplate.symlink ~/.gittemplate

gitntags-uninstall:
	sudo apt-get remove exuberant-ctags
	rm -ir ~/.gittemplate

show-symlinks:
	for file in $(patsubst %.symlink,%,$(symlinks)); do \
		echo $$file; \
	done

dependencies:
	sudo apt-get install build-essential cmake
	# We need to use vim-gtk to support copying to clipboard.
	sudo apt-get install vim-gtk
	sudo pip install pep8

install: update dependencies
	for file in $(patsubst %.symlink,%,$(symlinks)); do \
		ln -s $(current_directory)/$$file.symlink ~/.$$file; \
	done

update:
	git submodule update --init --recursive

uninstall:
	for file in $(patsubst %.symlink,%,$(symlinks)); do \
		rm -ir ~/.$$file; \
	done

# Compile YCM.
ycm: dependencies
	cd ./vim.symlink/bundle/vendor/YouCompleteMe && ./install.sh
