#!/bin/bash
#

if [[ "$AWS_PROFILE" = "" ]]
then
  echo "AWS_PROFILE is required in format 'workshop-aws-?' where ? is a digit from 1 to 15. You must setup your local profiles to make it work."
  return 1
fi
echo "workshop $1"

rm -fr .terraform

terraform init -backend-config=init-ws$1.tfvars

terraform workspace list

terraform state list

aws s3 ls --recursive m6-tfstate-ws$1
