Vim-alternate
=============

Vim-alternate allows to quickly switch between alternate files. A common use
case for this plugin is to switch between C/C++ header and source files.
Vim-alternate works by specifying an alternate extension for a specific
extension. In case the current buffer contains a file with an extension mapped
for vim-alternate, it allows to switch to a file with that extension at a
specific location using a single command or shortcut. The alternate file may be
located in a different directory relative to the current file. The directories
that are considered can be configured per extension.

This plugin is similar to the well-known a.vim, but simpler. Vim-alternate
weighs in at less than sixty lines of pure Vim script, and that includes
whitespace and comments. Furthermore, it simplifies dealing with a cycle of
alternates. For example, with vim-alternate it is possible to switch from a C++
source file (.cpp) to its corresponding header file (.h), then from the header
file to the corresponding header source file (.hpp) and finally back again to
the C++ source file. Something a.vim does not support as far as I know.

The latest version of vim-alternate can be found at:

  https://github.com/ton/vim-alternate

Bugs can be reported there as well.

Usage
=====

Vim-alternate provides one command that opens the alternate file for the file
loaded in the current buffer:

```Vim
:FindAlternate
```

No default keymappings are provided, but can easily be defined by the user. For
example, to map F4 to :FindAlternate, add the following lines to your Vim
configuration:

```Vim
nmap <silent> <F4> :FindAlternate<CR>
```

Vim-alternate will then search for an alternate file based on the current
configuration.

For more details and examples, see the OPTIONS section.

Options
=======

To set an option, include a line like the following in your Vim configuration:

```Vim
let g:AlternatePaths = ['../itf', '../src', '.', '..']
```

The remainder of this sections lists all available options:

g:AlternatePaths
----------------

Comma separated list of paths relative to the current file that are searched
for the alternate file.

Default value:

```Vim
['../itf', '../src', '.', '..']
```

g:AlternateExtensionMappings
----------------------------

List of dictionaries mapping an extension to an alternate extension.

Default value:

```Vim
[{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}, {'.c': '.h', '.h': '.c'}]
```

License
=======

BSD-2. See `LICENSE` for more details.
