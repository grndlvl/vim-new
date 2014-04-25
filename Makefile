current_directory := $(shell pwd)
files := $(wildcard *.symlink)

dependencies:
	sudo apt-get install build-essential cmake
	# We need to use vim-gtk to support copying to clipboard.
	sudo apt-get install vim-gtk
	sudo pip install pep8

update:
	git submodule init
	git submodule update

install: update dependencies
	for file in $(patsubst %.symlink,%,$(files)); do \
		ln -s $(current_directory)/$$file.symlink ~/.$$file; \
	done
	# Compile YCM.
	cd ~/.vim/bundle/vendor/YouCompleteMe && ./install.sh

uninstall:
	for file in $(patsubst %.symlink,%,$(files)); do \
		rm -ir ~/.$$file; \
	done
