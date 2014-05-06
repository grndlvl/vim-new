VimConfig
========

Install
------------

* Fork and clone this git repo.
* Run `make`

Uninstall
------------

* Run `make uninstall`

Add automatic ctags with git
------------

*This is separated out because it places git templates*

This will allow ctags to be generated and stored with the git files so that
ctags are created on various git hooks to keep them updated and fresh.

* To install run `make gitntags`
* To uninstall run `make uninstall_gitntags`

Some key bindings
------------

* `\n` - Open/Close navigation tree
* `CTRL+Left` - Prevoius buffer
* `CTRL+Right` - Next buffer
* `"+gY` - Copy selected text to clipboard
* `"+gP` or `SHFT-CTRL-v in insert mode` - Paste selected text from clipboard
* `F2` - Toggle line numbering from relative to normal

Todo
------------

* See about getting PyClewn up and running
