Vim-alternate
=============

Vim-alternate allows to quickly switch between alternate files. A common use
case for this plugin is to switch between C/C++ header and source files.
Vim-alternate works by specifying an alternate extension for a specific
extension. In case the current buffer contains a file with an extension mapped
for vim-alternate, it allows to switch to a file with that extension at a
specific location using a single command or shortcut. The alternate file may be
located in a different directory relative to the current file. The directories
that are considered can be configured separately.

This plugin is similar to the well-known a.vim, but simpler. Vim-alternate
weighs in at less than seventy lines of pure Vim script, and that includes
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
:Alternate
```

No default keymappings are provided, but can easily be defined by the user. For
example, to map F4 to :Alternate, add the following lines to your Vim
configuration:

```Vim
nmap <silent> <F4> :Alternate<CR>
```

Vim-alternate will then search for an alternate file based on the current
configuration.

For more details and examples, see the Example and Options sections.

Example
=======

Suppose vim-alternate is configured with the following alternate extension map:

```Vim
[{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}]
```

Using this alternate extension map, requesting the alternate file of `foo.cpp`
will trigger the plugin to search for the file `foo.h` in the alternate
directories, and in case that is not found, it will search for `foo.hpp`.

Extensions containing multiple dots are supported, and will be matched against
all file names that end with that extension. This implies that there is room
for amibiguity. Multiple extension mappings may match the extension or part of
the extension of some filename. Vim-alternate will always favor the extension
mapping that has the longest match with the extension of the current file name.
In case multiple mappings have defined the same longest matching extension, the
first mapping in the list of extension mappings is chosen.

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
['.', '../itf', '../include', '../src']
```

g:AlternateExtensionMappings
----------------------------

List of dictionaries mapping an extension to an alternate extension.

Default value:

```Vim
[{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp'}, {'.c': '.h', '.h': '.c'}]
```

This implies that in case you have a file named `foo.cpp` open, and ask for the
alternate file, the plugin will first search for `foo.h` in the alternate
directories, and in case that is not found, it will search for `foo.hpp`.

License
=======

BSD-2. See `LICENSE` for more details.
