#!/bin/bash
set -euo pipefail

json_data = $(cat <<EOF
	{
		"users": [
			{
				"first_name": "John",
				"last_name": "Smith",
				"City": "Oklahoma",
				"immigrationStauts": {
					"allowed": false
				}
			},
			{
				"first_name": "Kevin",
				"last_name": "Cordon",
				"City": "New Jersey",
				"immigrationStauts": {
					"allowed": true
				}
			},
			{
				"first_name": "James",
				"last_name": "Anderson",
				"City": "Houston",
				"immigrationStauts": {
					"allowed": true
				}
			}
		]
	}
)

echo $json_data 2> /dev/null || returnvalue=$?

if [[ returnvalue == 0 ]]; 
then
  echo "json data is available"    
		for users in $(echo "${json_data}" | jq -r '.users[] | @base64' ); do

			decode_json_data = $(echo $users | base64 --decode)

			FirstName=$(echo "${decode_json_data}" | jq -r '.first_name')
			LastName=$(echo "${decode_json_data}" | jq -r '.last_name')
			immigrationStauts=$(echo "${decode_json_data}" | jq -r '.immigrationStauts.allowed')

			echo "User is : ${FirstName} ${LastName} and ImmigrationStatus is ${immigrationStauts}"
		done
else
    echo "no json data available"
fi
