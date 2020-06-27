#!/bin/bash

INSTANCE_ID=$(curl -sS http://169.254.169.254/latest/meta-data/instance-id)
CURRENT_NAME=$(aws --region us-east-1 ec2 describe-tags --filters Name=resource-id,Values=$INSTANCE_ID Name=key,Values=Name --query Tags[].Value --output text)
IP=$(curl -sS http://169.254.169.254/latest/meta-data/hostname)
NEW_NAME=$CURRENT_NAME-$IP
echo $NEW_NAME
aws ec2 --region us-east-1 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$NEW_NAME

