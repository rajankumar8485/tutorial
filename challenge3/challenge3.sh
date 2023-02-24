#!/bin/bash
set -euo pipefail

user_data = $(cat "$1" | jq '.')

firstname = $2
lastname = $3

echo $user_data 2> /dev/null && returnvalue=$?

if [[ returnvalue == 0 ]]; 
then
  echo "user data is available"    
		user=$(echo "$user_data" | jq '.users[] | select(.first_name == "'"$first_name"'" and .last_name == "'"$last_name"'")')

		if [ -z "$user" ]; then
			echo "User not found"
			exit 1
		fi

		allowed=$(echo "$user" | jq '.immigrationStauts.allowed')
		citizenship=$(echo "$user" | jq '.immigrationStauts.citizenship')

		if [ "$allowed" == "true" ]; then
			if [ "$citizenship" == "true" ]; then
				echo "User is allowed to stay and has citizenship"
			else
				echo "User is allowed to stay but does not have citizenship"
			fi
		else
			echo "User is not allowed to stay"
		fi
else
    echo "no user data available"
fi
