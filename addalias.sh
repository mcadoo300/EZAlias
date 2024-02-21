#!/bin/zsh
# directory were you keep your bash aliases
rc='/home/marc/.zshrc'
# regex for validating alias name
valid_alias='^[a-zA-Z_][a-zA-Z0-9_]*$'
# valid arg counts for input checking
add_arg_count=3
arg_count=$#
# ensure at least one argument was passed
if [ $# -eq 0 ]; then
	echo "Error: No arguments were passed.\nExample: eza -a test \"echo 'this is a test' \" "
elif [[ "$1" == "-a" || "$1" == "-am" ]]; then # add alias
	if [ $# -eq $add_arg_count ]; then
		local alias_name=$2
		local command=$3
		if [[ $alias_name =~ $valid_alias ]]; then

			local exists=$(grep -c "^alias $alias_name=" $rc)
			if [ $exists -ne 0 ]; then
				echo "Error: An alias with that name already exists:"
				grep "^alias $alias_name=" $rc
			else
				echo "alias $alias_name=\"$command\"" >> $rc
				echo "alias created: $alias_name=\"$command\""
			fi
		else
			echo "Invalid alias name."
		fi

	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -a [ ALIAS ] [ COMMAND ]"
	fi
elif [[ "$1" == "-l" ]]; then # list aliases
	grep "^alias" $rc

else
	echo "Error: Unrecognized arguments."
fi
