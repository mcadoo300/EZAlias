### Ez Alias -- A lightweight CLI based alias manager

---

This tool allows for the creation/editing/removing/listing of aliases from the comfort of your favorite terminal.

---

## Instalation
You will want to clone this repo and place it wherever you find it convient.
`git clone https://github.com/mcadoo300/EZAlias.git`

## Configuration
You will need to change some file pathing.

In eza.sh change the rc variable to the location of your bash read command file.

`rc=/path/to/.shellrc`

Since I use zsh mine is located at /home/marc/.zshrc.

> Note: It is possible to source aliases from different files. If this is the case you should point rc to wherever you store your aliases.

If you would like to also use the manual page for this script, as well as create some of your own, you will need to move (or create a symlink) to the eza.man file. This file (eza.man) should be moved (or a link created in) `/usr/local/man/man1/eza.1`.

> Note: The .man extension was an orginizational decision and more info can be found under the 'Creating manual pages for your aliases' section. You may find that different aliases have different functionality and not all man pages go exactly into man1. For more information on standardized man page orginization [you can refer to this page](https://man7.org/linux/man-pages/man7/man-pages.7.html).


## Adding aliases
To add aliases use the option `zsh eza.sh -a yourAliasName "the command" `. I would recommend setting up an alias to call this script like so:

`zsh eza.sh -a eza "zsh /path/to/eza.sh`

> Note: For all following points in the readme eza implies the command `zsh eza.sh `.

## Listing aliases
To list aliases you can use the command `eza -l`. This goes into your bashrc file and reads out all the lines that start with alias.

## Removing aliases
To remove aliases use the command `eza -r alianName`.

## Editing existing aliases
To **c**hange the **c**ommand of an existing alias use the command `eza -cc aliasToEdit "new command"`

# Creating manual pages for your alias
If you are making an alias that is slightly complicated, calls a custom function, have a terrible memory like I do, or are making an alias that is slighly complicated you can use the command `eza -am yourAlias "your command"`.

This functions the same as the basic `-a` command. But at the end you will be prompted to fill in 3 sections 1. NAME 2.SYNOPSIS 3. DESCRIPTION .

> Note: This requires sudo permission.

A manual page will be added by default to /usr/local/man/man1/yourAlias.1 **AND A HARD LINK** to the file will be created in the directory in which you cloned this repo (but with the file extension .man). Editing either of these files will require sudo permission.

NOTE: This does require sudo privalages.

[This link](https://man7.org/linux/man-pages/man7/man-pages.7.html) provided above also details what should be in which section if you wish to follow standard conventions and other details if you wish to edit the manual page to include more information such as configuration, notes, etc.

