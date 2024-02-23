#!/bin/zsh
# directory were you keep your bash aliases
rc="$HOME/.zshrc"
# regex for validating alias name
valid_alias='^[a-zA-Z_][a-zA-Z0-9_]*$'
# valid arg counts for input checking
add_arg_count=3
remove_arg_count=2
edit_command_arg_count=3
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
				if [[ "$1" == "-am" ]]; then
					zsh $HOME/ezalias/createman.sh $alias_name
				fi
			fi
		else
			echo "Invalid alias name."
		fi

	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -a [ ALIAS ] [ COMMAND ]"
	fi
elif [[ "$1" == "-l" ]]; then # list aliases
	grep "^alias" $rc
elif [[ "$1" == "-r" ]]; then # remove alias
	if [ $# -eq $remove_arg_count ]; then
		local alias_name=$2
		local exists=$(grep -c "^alias $alias_name=" $rc)
		if [ $exists -eq 0 ]; then
			echo "Error: No alias found with that name"
		else
			echo "Removed the following alias:"
			grep "^alias $alias_name=" $rc
			grep -v "^alias $alias_name=" $rc > temp_file && mv temp_file $rc
		fi
	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -r [ ALIAS ]"
	fi
elif [[ "$1" == "-cc" ]]; then # change command
	if [ $# -eq $edit_command_arg_count ]; then
		local alias_name=$2
		local command=$3
		local exists=$(grep -c "^alias $alias_name=" $rc)
		if [ $exists -eq 0 ]; then
			echo "No alias found with that name.\nAdding alias."
		else
			echo "Edited the following alias:"
			grep "^alias $alias_name=" $rc
			grep -v "^alias $alias_name=" $rc > temp_file && mv temp_file $rc

		fi
		echo "alias $alias_name=\"$command\"" >> $rc
		echo "New alias:"
		grep "^alias $alias_name=" $rc
	else
		echo "Error: Invalid number of arguments pass.\n Proper syntax: eza -cc [ ALIAS ] [ COMMAND ]"
	fi

else
	echo "Error: Unrecognized arguments."
fi
