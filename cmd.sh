#!/bin/bash

set -e

get_docker_login() {

  if [[ -z $AWS_DEFAULT_REGION || -z $AWS_ACCESS_KEY_ID || -z $AWS_SECRET_ACCESS_KEY ]]; then
    echo 'AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are required values.' && exit 1;
  fi

  if [[ ! -z $REGISTRY_ID ]];then
    docker_login="$(aws ecr get-login --registry-ids $REGISTRY_ID)"
  else
    docker_login="$(aws ecr get-login)"
  fi

  export DOCKER_LOGIN="$docker_login"

  echo $docker_login
}

# $1 --> String since...
# $2 --> String ...until
get_value_between() {
  docker_login=${DOCKER_LOGIN:-$(get_docker_login)}
  echo "${docker_login}" | awk -F"$1" '{print $2}' | awk -F"$2" '{print $1}'
}

get_username() {
  get_value_between '-u ' ' '
}

get_password() {
  get_value_between '-p ' ' '
}

get_email() {
  get_value_between '-e ' ' '
}

get_registry_url() {
  echo ${DOCKER_LOGIN##* }
}

help () {
  echo "Usage: $0 {get_docker_login|get_username|get_email|get_password|get_registry_url|help}, in other case the complete the docker login command will be displayed"
  echo "Required env variables: AWS_DEFAULT_REGION, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
  echo "Optional env variables: REGISTRY_ID (od value of the aws ecr registry)"
}

if [ $# -gt 1 ]; then

  # Main options
  case "$1" in
    help)
      help
      exit 0
      ;;
    get_docker_login)
      shift
      get_docker_login
      exit $?
      ;;
    get_username)
      shift
      get_username
      exit $?
      ;;
    get_email)
      shift
      get_email
      exit $?
      ;;
    get_password)
      shift
      get_password
      exit $?
      ;;
    *)
      echo $docker_login
      exit 1
  esac
fi