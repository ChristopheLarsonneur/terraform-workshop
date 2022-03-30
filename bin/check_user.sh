#!/bin/bash

if [[ "$AWS_PROFILE" = "" ]] 
then
  echo "AWS_PROFILE setup is required."
  return 1
fi

echo "workshop-user: Checking..."

ACTIVE_KEYS="$(aws iam list-access-keys --user-name workshop-user)"

for key in $(echo "$ACTIVE_KEYS" | jq -r .AccessKeyMetadata[].AccessKeyId)
do

  if [[ "$(echo "$ACTIVE_KEYS" | jq -r '.AccessKeyMetadata[]| if .AccessKeyId == "'$key'" then .Status else "" end')" = Active ]]
  then
    printf "Access Key    : \e[32;1m$key ACTIVE\e[0m\n"
  else
    printf "Access Key    : \e[33m$key INACTIVE\e[0m\n"
  fi
done

aws iam get-login-profile --user-name workshop-user > /dev/null 2>&1
if [[ $? -eq 0 ]]
then
  printf "Console access: \e[32;1mACTIVE\e[0m\n"
else
  printf "Console access: \e[33mINACTIVE\e[0m\n"
fi