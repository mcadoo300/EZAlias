#!/bin/zsh

# source /path/to/ezalias/config
source $HOME/ezalias/config

touch $1.man
sudo echo ".TH $1(1) " >> $1.man
sudo echo ".SH NAME " >> $1.man
sudo echo ".B $1 - " >> $1.man

echo "Enter a brief description of your alias name.\nA description of its use comes later."
read descn
sudo echo "$descn" >> $1.man

sudo echo ".SH SYNOPSIS " >> $1.man
echo "Enter the command/function interface.\nExample: youralias [OPTION], youralias [FILE], etc.)"
read syn
sudo echo "$syn" >> $1.man

sudo echo ".SH DESCRIPTION " >> $1.man
echo "Enter a description of how to use your alias."
read desc
sudo echo "$desc" >> $1.man
sudo mv ./$1.man $file_path/ezalias/$1.man
sudo ln $file_path/ezalias/$1.man /usr/local/man/man1/$1.1

echo "You may now access your manual page by entering 'man $1'"

