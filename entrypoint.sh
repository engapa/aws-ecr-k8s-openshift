#!/bin/sh

if [[ -z $AWS_DEFAULT_REGION || -z $AWS_ACCESS_KEY_ID || -z $AWS_SECRET_ACCESS_KEY ]]; then
  echo 'AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are required values.' && exit 1;
fi

if [[ ! -z $REGISTRY_IDS ]];then
  for registry in $REGISTRY_IDS; do
    aws ecr get-login --registry-ids $registry | awk -F'-p ' '{print $2}' | awk -F' ' '{print $1}'
  done
else
  aws ecr get-login | awk -F'-p ' '{print $2}' | awk -F' ' '{print $1}'
fi
