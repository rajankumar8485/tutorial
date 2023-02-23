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
		for users in $(echo "${json_data}" | jq -c '.users'); do

			FirstName=$(echo "${users}" | jq -r '.first_name')
			LastName=$(echo "${users}" | jq -r '.last_name')
			immigrationStauts=$(echo "${users}" | jq -r '.immigrationStauts.allowed')

			echo "firstName : ${FirstName}"
			echo "lastName : ${LastName}"
			echo "ImmigrationStatus : ${immigrationStauts}"
		done
else
    echo "no json data available"
fi
