current_directory := $(shell pwd)
files := $(wildcard *.symlink)

dependencies:
	sudo apt-get install build-essential cmake
	sudo pip install pep8

update:
	git submodule init
	git submodule update

install: update dependencies post-install
	for file in $(patsubst %.symlink,%,$(files)); do \
		ln -s $(current_directory)/$$file.symlink ~/.$$file; \
	done

post-install:
	cd ~/.vim/bundle/vendor/YouCompleteMe && ./install.sh

uninstall:
	for file in $(patsubst %.symlink,%,$(files)); do \
		rm -ir ~/.$$file; \
	done
