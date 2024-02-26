#!/bin/zsh
### CONFIG ### -> to be moved to sep config file later
# directory where you keep your bash aliases
src1="$HOME/.zshrc"
src2="$HOME/aliases/aliases_git"
# add list of sources to src_list= ( $src1 $src2 ... )
src_list=( $src1 $src2 )
rc=$src1 # default for src1

### GLOBAL VARIABLES ###
# regex for validating alias name
valid_alias='^[a-zA-Z_][a-zA-Z0-9_]*$'
# valid arg counts for input checking
add_arg_count=3
remove_arg_count=2
edit_command_arg_count=3
### ARGUMENTS ###
arg_count=$#
option=$1
alias_name=$2
command=$3

### functions ###
# writes an alias to rc
function write_alias_to_file {
	local exists=$(grep -c "^alias $alias_name=" $rc)
	if [ $exists -ne 0 ]; then
		echo "Error: An alias with that name already exists:"
		grep "^alias $alias_name=" $rc
	else
		echo "alias $alias_name=\"$command\"" >> $rc
		echo "alias created: $alias_name=\"$command\""
		if [[ "$option" == "-am" ]]; then
			zsh $HOME/ezalias/createman.sh $alias_name
		fi
	fi

}
# set rc variable to specific file
# will prompt user to enter index
# if more than one source file present in list
function get_alias_file {
	# get alias source file
	if [ ${#src_list[@]} -eq 1 ]; then
		rc=${src_list[@]} # bash and zsh have different indexing so @ is used
	else
		local valid_input=false
		while [ $valid_input = false ]
		do
			echo "Input file would you like to add the alias to?"
			for (( i = 1; i <= ${#src_list[@]}; i++))
			do
				echo  "($i) ${src_list[i]}\t"
			done
			read rc_src
			if [[ 0 -lt $rc_src ]] && [[ $rc_src -le ${#src_list[@]} ]]; then
				rc=${src_list[$rc_src]}
				valid_input=true
			else
				echo "Please enter an integer between 1 and ${#src_list[@]}(inclusive)"
			fi
		done
	fi
}
# iterate through all alias source files
# print out aliases
function list_aliases {
	for src in ${src_list[@]}
	do
		echo "Aliases from $src:"
		grep "^alias" $src
		echo "\n"
	done
}

# remove alias_name
function remove_alias {
	if [ ${#src_list[@]} -eq 1 ]; then
		local exists=$(grep -c "^alias $alias_name=" $rc)
		if [ $exists -eq 0 ]; then
			echo "Error: No alias found with that name"
		else
			echo "Removed the following alias:"
			grep "^alias $alias_name=" $rc
			grep -v "^alias $alias_name=" $rc > temp_file && mv temp_file $rc
		fi
	else
		local i=1
		local not_found=true
		while [ $i -le ${#src_list[@]} ] && [ $not_found = true ]
		do
			echo "Searching file ${src_list[$i]}..."
			local exists=$(grep -c "^alias $alias_name=" ${src_list[$i]})
			if [ $exists -eq 1 ]; then
				echo "Removed the following alias:"
				grep "^alias $alias_name=" ${src_list[$i]}
				grep -v "^alias $alias_name=" ${src_list[$i]} > temp_file && mv temp_file ${src_list[$i]}
				not_found=false
			fi
			((i+=1))
		done
		if [ $not_found = true ]; then
			echo "Error: Alias not found."
		fi
	fi
}

function edit_alias {
	if [ ${#src_list[@]} -eq 1 ]; then
		rc=${src_list[@]} # bash and zsh have different indexing so @ is used
		local exists=$(grep -c "^alias $alias_name=" $rc)
		if [ $exists -eq 0 ]; then
			echo "No alias found with that name"
		else
			echo "Edited the following alias:"
			grep "^alias $alias_name=" $rc
			grep -v "^alias $alias_name=" $rc > temp_file && mv temp_file $rc
		fi
		echo "alias $alias_name=\"$command\"" >> $rc
		echo "New alias:"
		grep "^alias $alias_name=" $rc
	else
		local i=1
		local not_found=true
		while [ $i -le ${#src_list[@]} ] && [ $not_found = true ]
		do
			echo "Searching file ${src_list[$i]}..."
			local exists=$(grep -c "^alias $alias_name=" ${src_list[$i]})
			if [ $exists -eq 1 ]; then
				echo "Edited the following alias:"
				grep "^alias $alias_name=" ${src_list[$i]}
				grep -v "^alias $alias_name=" ${src_list[$i]} > temp_file && mv temp_file ${src_list[$i]}
				not_found=false
				echo "alias $alias_name=\"$command\"" >> ${src_list[$i]}
				echo "New alias:"
				grep "^alias $alias_name=" ${src_list[$i]}
			fi
			((i+=1))
		done
		if [ $not_found = true ]; then
			echo "No alias found with that name."
			get_alias_file
			write_alias_to_file
		fi
	fi
}


# ensure at least one argument was passed
if [ $arg_count -eq 0 ]; then
	echo "Error: No arguments were passed.\nExample: eza -a test \"echo 'this is a test' \" "
elif [[ "$option" == "-a" || "$option" == "-am" ]]; then # add alias
	if [ $# -eq $add_arg_count ]; then
		if [[ $alias_name =~ $valid_alias ]]; then
			get_alias_file
			write_alias_to_file
		else
			echo "Invalid alias name."
		fi

	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -a [ ALIAS ] [ COMMAND ]"
	fi
elif [[ "$option" == "-l" ]]; then # list aliases
	list_aliases
elif [[ "$option" == "-r" ]]; then # remove alias
	if [ $# -eq $remove_arg_count ]; then
		remove_alias
	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -r [ ALIAS ]"
	fi
elif [[ "$option" == "-cc" ]]; then # change command
	if [ $# -eq $edit_command_arg_count ]; then
		edit_alias
	else
		echo "Error: Invalid number of arguments pass.\n Proper syntax: eza -cc [ ALIAS ] [ COMMAND ]"
	fi

else
	echo "Error: Unrecognized arguments."
fi
