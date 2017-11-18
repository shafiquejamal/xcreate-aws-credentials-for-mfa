#!/usr/local/bin/bash
# From: https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash-script
# declaring a couple of associative arrays
declare -A arguments=();  
declare -A variables=();

# declaring an index integer
declare -i index=1;

# any variables you want to use here
# on the left left side is argument label or key (entered at the command line along with it's value) 
# on the right side is the variable name the value of these arguments should be mapped to.
# (the examples above show how these are being passed into this script)
variables["--existing-profile"]="existing_profile";  
variables["--mfa-profile"]="mfa_profile";  
variables["--serial-number"]="serial_number";  
variables["--token-code"]="token_code";
variables["--output"]="output";
variables["--region"]="region";
variables["-o"]="output";
variables["-r"]="region";
variables["-e"]="existing_profile";  
variables["-m"]="mfa_profile";  
variables["-s"]="serial_number";  
variables["-t"]="token_code";

# $@ here represents all arguments passed in
for i in "$@"  
do  
  arguments[$index]=$i;
  prev_index="$(expr $index - 1)";

  # this if block does something akin to "where $i contains ="
  # "%=*" here strips out everything from the = to the end of the argument leaving only the label
  if [[ $i == *"="* ]]
    then argument_label=${i%=*} 
    else argument_label=${arguments[$prev_index]}
  fi

  # this if block only evaluates to true if the argument label exists in the variables array
  if [[ -n ${variables[$argument_label]} ]]
    then
        # dynamically creating variables names using declare
        # "#$argument_label=" here strips out the label leaving only the value
        if [[ $i == *"="* ]]
            then declare ${variables[$argument_label]}=${i#$argument_label=} 
            else declare ${variables[$argument_label]}=${arguments[$index]}
        fi
  fi

  index=index+1;
done;

if [ $existing_profile ]
then
	profile="--profile $existing_profile"
else
	profile=""
fi	


# From https://gist.github.com/ddgenome/f13f15dd01fb88538dd6fac8c7e73f8c
credentials_json=$(aws --output json $profile sts get-session-token --serial-number "$serial_number" --token-code $token_code)
rv="$?"

# echo "$credentials_json"
if [[ $rv -eq 0 ]]; then
	echo ""
	echo "[$mfa_profile]"
	echo "output=$output"
	echo "region=$region"
	echo "aws_access_key_id=$(echo $credentials_json | jq .Credentials.AccessKeyId | sed -e 's/"//g')"
	echo "aws_secret_access_key=$(echo $credentials_json | jq .Credentials.SecretAccessKey | sed -e 's/"//g')"
	echo "aws_session_token=$(echo $credentials_json | jq .Credentials.SessionToken | sed -e 's/"//g')"
fi