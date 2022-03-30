#!/bin/bash
#

if [[ "$1" = "" ]]
then
  echo "Usage is $0 <workshop index number 1 to 15"
  return 1
fi
echo "workshop $1"

export AWS_PROFILE=workshop-aws-$1
echo "AWS_PROFILE=$AWS_PROFILE"

aws s3 ls --recursive m6-tfstate-ws$1

./check_user.sh
