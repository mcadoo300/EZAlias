#!/bin/zsh
# directory where you keep your bash aliases
#rc="$HOME/.zshrc"
src1="$HOME/.zshrc"
#src2="$HOME/aliases/aliases_git"
# add list of sources to src_list= ( $src1 $src2 ... )
src_list=( $src1 )


# regex for validating alias name
valid_alias='^[a-zA-Z_][a-zA-Z0-9_]*$'
# valid arg counts for input checking
add_arg_count=3
remove_arg_count=2
edit_command_arg_count=3
arg_count=$#
# ensure at least one argument was passed
if [ $arg_count -eq 0 ]; then
	echo "Error: No arguments were passed.\nExample: eza -a test \"echo 'this is a test' \" "
elif [[ "$1" == "-a" || "$1" == "-am" ]]; then # add alias
	if [ $# -eq $add_arg_count ]; then
		
		local alias_name=$2
		local command=$3
		if [[ $alias_name =~ $valid_alias ]]; then
			# get alias source file
			if [ ${#src_list[@]} -eq 1 ]; then
				local rc=${src_list[@]} # bash and zsh have different indexing so @ is used
				echo $rc
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
						local rc=${src_list[$rc_src]}
						valid_input=true
					else
						echo "Please enter an integer between 1 and ${#src_list[@]}"
					fi
				done
	
			fi
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
	for src in ${src_list[@]}
	do
		echo "Aliases from $src:"
		grep "^alias" $src
		echo "\n"
	done
elif [[ "$1" == "-r" ]]; then # remove alias
	if [ $# -eq $remove_arg_count ]; then
		# get alias source file
		# get alias source file
		local alias_name=$2
		if [ ${#src_list[@]} -eq 1 ]; then
			local rc=${src_list[@]} # bash and zsh have different indexing so @ is used
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
	else
		echo "Error: Invalid number of arguments passed.\nProper syntax: eza -r [ ALIAS ]"
	fi
elif [[ "$1" == "-cc" ]]; then # change command
	if [ $# -eq $edit_command_arg_count ]; then
		# get alias source file
		# get alias source file
		local alias_name=$2
		local command=$3
		if [ ${#src_list[@]} -eq 1 ]; then
			local rc=${src_list[@]} # bash and zsh have different indexing so @ is used
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
				echo "Error: Alias not found."
			fi
		fi
	else
		echo "Error: Invalid number of arguments pass.\n Proper syntax: eza -cc [ ALIAS ] [ COMMAND ]"
	fi

else
	echo "Error: Unrecognized arguments."
fi
