current_directory := $(shell pwd)
symlinks := $(wildcard *.symlink)

all: install ycm

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
	git submodule init
	git submodule update

uninstall:
	for file in $(patsubst %.symlink,%,$(symlinks)); do \
		rm -ir ~/.$$file; \
	done

# Compile YCM.
ycm: dependencies
	cd ./vim.symlink/bundle/vendor/YouCompleteMe && ./install.sh
