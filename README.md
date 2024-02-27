# Ez Alias -- A lightweight CLI based alias manager

This tool allows you to create, edit, remove, and list aliases from the comfort of your favorite terminal.

## Installation 
You will want to clone this repo and place it wherever you find it convenient. The default configuration assumes it has been installed in the `$HOME` directory.

`git clone https://github.com/mcadoo300/EZAlias.git`
## Configuration
You may need to change some file pathing depending on how you organize your aliases, where you cloned this repo or depending on your shell.
In the `config` file change the src1 variable to point to the location of your aliases. By default the vairable is set to point at your `$HOME` directory and is set up for a z shell:
`src1="$HOME/.zshrc"`

All sources are added to the list of sources `src_list`. This makes adding additional source files easy, but by default only includes src1.

> Note: It is possible to source aliases from different file(s). If this is the case you should point src1 to wherever you store your aliases. If you use **multiple sources** for aliases you want to add all sources to src_list [which only stores src1 by default].


If you would like to also use the manual page for this script, as well as create some of your own, you will need to move (or create a symlink) to the `eza.man` file. This file (eza.man) should be moved to (or a link created in)  `/usr/local/man/man1/eza.1`. 

Example: `sudo ln eza.man /usr/local/man/man1/eza.1`

You may also have to change the variable which points to the 'createman.sh' script within the `config` file.

>Note: The default location is `man_src=$HOME/ezalias/createman.sh`.


> Note: The .man extension was an organizational decision for easy tracking/editing. More info can be found under the 'Creating manual pages for your aliases' section. For more information on standardized man page organization [you can refer to this page](https://man7.org/linux/man-pages/man7/man-pages.7.html).

## Adding aliases
To add aliases use the option `zsh eza.sh -a yourAliasName "the command" `. I would recommend setting up an alias to call this script like so:
`zsh eza.sh -a eza "zsh /path/to/eza.sh`
> Note: For all following points in the readme `eza` implies the command `zsh eza.sh `.
## Listing aliases
To list aliases you can use the command `eza -l`. This goes into your bashrc file and reads out all the lines that start with alias.
## Removing aliases
To remove aliases use the command `eza -r aliasName`.
## Editing existing aliases
To **C**hange the **C**ommand of an existing alias use the command `eza -cc aliasToEdit "new command"`
## Creating manual pages for your alias
If you are making an alias that is slightly complicated, calls a custom function, have a terrible memory like I do, or are making an alias that is slightly complicated you can use the command `eza -am yourAlias "your command"`.
This functions the same as the basic `-a` command. But at the end you will be prompted to fill in 3 sections of a manual page: 1. NAME 2.SYNOPSIS 3. DESCRIPTION .
> Note: This requires sudo permission.

A manual page will be added by default to `/usr/local/man/man1/yourAlias.1` **AND A HARD LINK** to the file will be created in the directory in which you cloned this repo (but with the file extension .man). Editing either of these files will require sudo permission. Once this is complete you can access the description of your alias by using the command `man yourAlias`.

[This link](https://man7.org/linux/man-pages/man7/man-pages.7.html) (also provided above) details what types of manuals should be in which section of the `.../man/` directory. If you wish to follow standard conventions or if you wish to edit the manual page to include more information such as configuration, notes, etc. it may be a useful reference.

