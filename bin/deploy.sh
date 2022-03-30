#!/bin/bash

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
do
  export AWS_PROFILE=workshop-aws-$i
  terraform workspace select ws$i || terraform workspace new ws$i
  TF_VAR_workshop_id=$i terraform apply -auto-approve
done