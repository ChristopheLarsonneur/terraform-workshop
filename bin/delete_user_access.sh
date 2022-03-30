#!/bin/bash
#

if [[ "$AWS_PROFILE" = "" ]] 
then
  echo "AWS_PROFILE setup is required."
  return 1
fi

aws iam delete-login-profile --user-name workshop-user > /dev/null 2>&1

for key in $(aws iam list-access-keys --user-name workshop-user | jq -r .AccessKeyMetadata[].AccessKeyId)
do
  aws iam update-access-key --user-name workshop-user --status Inactive --access-key-id $key
done
./check_user.sh